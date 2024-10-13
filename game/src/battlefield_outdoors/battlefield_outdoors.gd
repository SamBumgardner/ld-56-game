class_name BattlefieldOutdoors extends Control

signal charge_start()
signal charge_warmup(duration: float)
signal charge_action(duration: float)
signal charge_impact(duration: float)
signal charge_cooldown(duration: float)
signal charge_finish()

signal health_empty()
signal insufficient_fuel()

@onready var war_transport: BattlefieldOutdoorsWarTransport = $AnchorOfWarTransport/BattlefieldOutdoorsWarTransport
@onready var battlefield_outdoors_hud: BattlefieldOutdoorsHud = $BattlefieldOutdoorsHud

var combat_math_formulas: CombatMathFormulas = CombatMathFormulas.new()
var charge_sequence_tween: Tween

func _ready() -> void:
    insufficient_fuel.connect(battlefield_outdoors_hud._on_insufficient_fuel)
    battlefield_outdoors_hud.dice_roll_requested.connect(_on_roll_requested)
    battlefield_outdoors_hud.initiate_charge_requested.connect(_begin_charge_sequence)

    _connect_hud_charge_events()
    charge_cooldown.connect(_on_charge_cooldown)
    charge_impact.connect(_on_charge_impact)

    health_empty.connect(_on_health_empty)

    _generate_and_scale_next_barrier()

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

func _on_charge_impact(_duration: float) -> void:
    _apply_combat_damage()

func _apply_combat_damage() -> void:
    var updated_health = Database.war_transport_health_current
    var player_strength = combat_math_formulas.total_dice_with_matching_stat_type_multiplier(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )
    var damage_amount = (
        Database.current_barrier_cost_to_overcome_number - player_strength
    )

    if damage_amount > 0:
        updated_health -= damage_amount
        Database.set_war_transport_health_current(
            updated_health
        )

    if updated_health <= 0:
        health_empty.emit()

func _on_charge_cooldown(_duration: float) -> void:
    _generate_and_scale_next_barrier()
    _apply_combat_rewards()

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
    Database.set_money(Database.current_money + randi_range(1, 100))
    Database.set_fuel(Database.current_fuel + randi_range(1, 3))
    Database.set_barriers_overcome_count(
        Database.barriers_overcome_count
        + 1
    )

func _on_health_empty() -> void:
    print_debug('Game over, health has reached ', Database.war_transport_health_current)
    if charge_sequence_tween != null and charge_sequence_tween.is_valid():
        charge_sequence_tween.kill()
    # initiate some sequence of events for a cool game over
    var game_over_sequence = create_tween()
    game_over_sequence.tween_interval(2)
    game_over_sequence.tween_callback(
        get_tree().change_scene_to_packed.bind(preload("res://src/start_menu/StartMenu.tscn")))

func _on_roll_requested():
    if has_enough_fuel():
        Database.set_fuel(Database.current_fuel - Database.current_reroll_fuel_cost)
        roll_dice()

func has_enough_fuel() -> bool:
    var enough_fuel: bool = Database.current_fuel >= Database.current_reroll_fuel_cost
    if not enough_fuel:
        insufficient_fuel.emit()
    return enough_fuel

func roll_dice() -> void:
    var character_die_slots = Database.current_character_die_slots
    for i: int in character_die_slots.size():
        var character_die_slot: CharacterDieSlot = character_die_slots[i]

        if character_die_slot.is_frozen:
            continue

        character_die_slot.last_roll_result = character_die_slot.roll_action()

    Database.set_current_character_die_slots(character_die_slots, true)
