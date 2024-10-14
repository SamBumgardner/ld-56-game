class_name BattlefieldOutdoors extends Control

signal charge_start()
signal charge_warmup(duration: float)
signal charge_action(duration: float)
signal charge_impact(duration: float)
signal charge_cooldown(duration: float)
signal charge_finish()

signal dice_roll_started()
signal health_empty()
signal insufficient_fuel()

@onready var war_transport: BattlefieldOutdoorsWarTransport = $AnchorOfWarTransport/BattlefieldOutdoorsWarTransport
@onready var barrier: BattlefieldOutdoorsBarrier = $AnchorOfBarrier/BattlefieldOutdoorsBarrier
@onready var battlefield_outdoors_hud: BattlefieldOutdoorsHud = $BattlefieldOutdoorsHud

var combat_math_formulas: CombatMathFormulas = CombatMathFormulas.new()
var charge_sequence_tween: Tween
var combat_result: CombatResultsSummary.CombatResult = CombatResultsSummary.CombatResult.new()

func _ready() -> void:
    insufficient_fuel.connect(battlefield_outdoors_hud._on_insufficient_fuel)
    battlefield_outdoors_hud.dice_roll_requested.connect(_on_roll_requested)
    battlefield_outdoors_hud.initiate_charge_requested.connect(_begin_charge_sequence)

    _connect_hud_charge_events()
    charge_warmup.connect(_on_charge_warmup)
    charge_action.connect(_on_charge_action)
    charge_impact.connect(_on_charge_impact)
    charge_cooldown.connect(_on_charge_cooldown)
    charge_finish.connect(_on_charge_finish)

    health_empty.connect(_on_health_empty)

    if Database.current_barrier_data == null:
        _generate_and_scale_next_barrier()
    else:
       Database.set_current_barrier_data(Database.current_barrier_data)

func _connect_hud_charge_events() -> void:
    charge_start.connect(battlefield_outdoors_hud._on_charge_start)
    charge_warmup.connect(battlefield_outdoors_hud._on_charge_warmup)
    charge_action.connect(battlefield_outdoors_hud._on_charge_action)
    charge_impact.connect(battlefield_outdoors_hud._on_charge_impact)
    charge_cooldown.connect(battlefield_outdoors_hud._on_charge_cooldown)
    charge_finish.connect(battlefield_outdoors_hud._on_charge_finish)

func transition_in() -> void:
    Database.initialize_missing_die_slots()
    battlefield_outdoors_hud.crew_member_selector.refresh()
    battlefield_outdoors_hud.refresh_calculations()
    battlefield_outdoors_hud.character_info_panel.display_character(null)
    battlefield_outdoors_hud._enable_interaction()

func transition_out() -> void:
    battlefield_outdoors_hud._disable_interaction()

func _begin_charge_sequence() -> void:
    if charge_sequence_tween != null and charge_sequence_tween.is_running():
        push_error("Attempted to start a charge while one was already in progress.")
        return

    charge_sequence_tween = create_tween()
    charge_sequence_tween.tween_callback(charge_warmup.emit.bind(ChargeSequence.WARMUP_DURATION))
    charge_sequence_tween.tween_interval(ChargeSequence.WARMUP_DURATION)
    charge_sequence_tween.tween_callback(charge_action.emit.bind(ChargeSequence.ACTION_DURATION))
    charge_sequence_tween.tween_interval(ChargeSequence.ACTION_DURATION)
    charge_sequence_tween.tween_callback(charge_impact.emit.bind(ChargeSequence.IMPACT_DURATION))
    charge_sequence_tween.tween_interval(ChargeSequence.IMPACT_DURATION)
    charge_sequence_tween.tween_callback(charge_cooldown.emit.bind(ChargeSequence.COOLDOWN_DURATION))
    charge_sequence_tween.tween_interval(ChargeSequence.COOLDOWN_DURATION)
    charge_sequence_tween.tween_callback(charge_finish.emit)

    charge_start.emit()

func _on_charge_warmup(duration: float) -> void:
    var player_strength = combat_math_formulas.total_dice_with_matching_stat_type_multiplier(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )
    barrier.display_power(duration)
    war_transport.display_combat_stats(player_strength, duration)
    war_transport.charge_warmup(duration)

func _on_charge_action(duration: float) -> void:
    war_transport.charge_to_target(barrier.start_global_position, duration)

func _on_charge_impact(duration: float) -> void:
    _apply_combat_damage()
    if Database.war_transport_health_current > 0:
        war_transport.charge_followthrough(war_transport.global_position + Vector2(200, 0), duration)
        barrier.animate_destruction(duration)
    else:
        war_transport.hide_power(duration)
        war_transport.defeated_knockback(duration)


func _apply_combat_damage() -> void:
    var updated_health = Database.war_transport_health_current
    var player_strength = combat_math_formulas.total_dice_with_matching_stat_type_multiplier(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )
    var damage_amount = max(
        Database.current_barrier_cost_to_overcome_number - player_strength,
        0
    )
    combat_result.health_change = -damage_amount

    if damage_amount > 0:
        updated_health -= damage_amount
        Database.set_war_transport_health_current(
            updated_health
        )

    if updated_health <= 0:
        health_empty.emit()

func _on_charge_cooldown(duration: float) -> void:
    war_transport.hide_power(duration)
    war_transport.return_to_start_position(duration)
    _generate_and_scale_next_barrier()
    _apply_combat_rewards()
    battlefield_outdoors_hud.set_combat_results(combat_result)

func _on_charge_finish() -> void:
    if _should_save_checkpoint():
        _save_checkpoint()
    barrier.new_barrier_scroll_onscreen(2, Vector2(500, 0))

func _generate_and_scale_next_barrier() -> void:
    var new_barrier: BarrierData = _generate_barrier_data()

    if new_barrier.cost_to_overcome != Database.current_barrier_cost_to_overcome_number:
        Database.set_current_barrier_cost_to_overcome_number(new_barrier.cost_to_overcome)
    if Database.current_barrier_stat_type_to_overcome != new_barrier.weakness_type:
        Database.set_current_barrier_stat_type_to_overcome(new_barrier.weakness_type)

    Database.set_current_barrier_data(new_barrier)

func _generate_barrier_data() -> BarrierData:
    var cost_to_overcome = Database.current_barrier_cost_to_overcome_number \
        + Database.barriers_linear_scale_amount
    var random_display_name = BarrierData._get_random_display_name()
    var random_stat_type = Database.StatType.values().pick_random()
    return BarrierData.new(random_display_name, random_stat_type,
        cost_to_overcome)

func _apply_combat_rewards() -> void:
    var money_change = randi_range(1, 100)
    var fuel_change = randi_range(1, 3)
    combat_result.money_change = money_change
    combat_result.fuel_change = fuel_change

    Database.set_money(Database.current_money + money_change)
    Database.set_fuel(Database.current_fuel + fuel_change)
    Database.set_barriers_overcome_count(
        Database.barriers_overcome_count
        + 1
    )

func _should_save_checkpoint() -> bool:
    const BARRIERS_PER_CHECKPOINT = 5
    return Database.barriers_overcome_count % BARRIERS_PER_CHECKPOINT == 0

func _save_checkpoint() -> void:
    Database.save_checkpoint()

func _on_health_empty() -> void:
    if charge_sequence_tween != null and charge_sequence_tween.is_valid():
        charge_sequence_tween.stop()
        charge_sequence_tween.kill()
    # initiate some sequence of events for a cool game over
    const game_over_duration: float = 5
    var game_over_sequence = create_tween()
    game_over_sequence.tween_interval(ChargeSequence.IMPACT_DURATION * 2)
    game_over_sequence.tween_callback(war_transport.create_destruction_tweens.bind(game_over_duration))
    game_over_sequence.tween_interval(game_over_duration)
    game_over_sequence.tween_callback(
        get_tree().change_scene_to_packed.bind(preload("res://src/game_over/game_over.tscn")))

func _on_roll_requested():
    if _has_enough_fuel():
        dice_roll_started.emit()
        Database.set_fuel(Database.current_fuel - Database.current_reroll_fuel_cost)
        _roll_dice()

func _has_enough_fuel() -> bool:
    var enough_fuel: bool = Database.current_fuel >= Database.current_reroll_fuel_cost
    if not enough_fuel:
        insufficient_fuel.emit()
    return enough_fuel

func _roll_dice() -> void:
    var character_die_slots = Database.current_character_die_slots
    for i: int in character_die_slots.size():
        var character_die_slot: CharacterDieSlot = character_die_slots[i]

        if character_die_slot.is_frozen:
            continue

        character_die_slot.last_roll_result = character_die_slot.roll_action()

    Database.set_current_character_die_slots(character_die_slots, true)

func _on_checkpoint_saved() -> void:
    battlefield_outdoors_hud.screen_notification.display_notification(
        ScreenNotification.ScreenNotificationType.CHECKPOINT,
        Database.CHECKPOINT_SAVED_MESSAGE,
        Database.CHECKPOINT_SAVED_DURATION
    )
