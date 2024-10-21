class_name BattlefieldOutdoors extends Control

signal charge_start()
signal charge_warmup(duration: float)
signal charge_action(duration: float)
signal charge_impact(duration: float)
signal charge_cooldown(duration: float)
signal charge_finish()

signal camera_focus_moving(distance: Vector2, duration: float)

signal victory(duration: float)

signal milestone_achieved()

signal dice_roll_started()
signal health_empty()
signal insufficient_fuel()
signal all_locked()

@onready var war_transport: BattlefieldOutdoorsWarTransport = $AnchorOfWarTransport/BattlefieldOutdoorsWarTransport
@onready var barrier: BattlefieldOutdoorsBarrier = $AnchorOfBarrier/BattlefieldOutdoorsBarrier
@onready var battlefield_outdoors_hud: BattlefieldOutdoorsHud = $BattlefieldOutdoorsHud

var combat_math_formulas: CombatMathFormulas = CombatMathFormulas.new()
var charge_sequence_tween: Tween
var combat_result: CombatResultsSummary.CombatResult = CombatResultsSummary.CombatResult.new()
var checkpoint_reached: bool = false

func _ready() -> void:
    insufficient_fuel.connect(battlefield_outdoors_hud._on_insufficient_fuel)
    all_locked.connect(battlefield_outdoors_hud._on_all_locked)
    battlefield_outdoors_hud.dice_roll_requested.connect(_on_roll_requested)
    battlefield_outdoors_hud.initiate_charge_requested.connect(_begin_charge_sequence)

    _connect_hud_charge_events()
    charge_warmup.connect(_on_charge_warmup)
    charge_action.connect(_on_charge_action)
    charge_impact.connect(_on_charge_impact)
    charge_cooldown.connect(_on_charge_cooldown)
    charge_finish.connect(_on_charge_finish)

    health_empty.connect(_on_health_empty)
    
    Database.region_changed.connect(_on_region_changed)

    if Database.current_barrier_data == null:
        _generate_and_scale_next_barrier()
    else:
       Database.set_current_barrier_data(Database.current_barrier_data)

func _connect_hud_charge_events() -> void:
    charge_start.connect(battlefield_outdoors_hud._on_charge_start)
    charge_warmup.connect(battlefield_outdoors_hud._on_charge_warmup)
    charge_impact.connect(battlefield_outdoors_hud._on_charge_impact)
    charge_cooldown.connect(battlefield_outdoors_hud._on_charge_cooldown)
    charge_finish.connect(battlefield_outdoors_hud._on_charge_finish)

func transition_in() -> void:
    Database.initialize_missing_die_slots()
    battlefield_outdoors_hud.crew_member_selector.refresh()
    battlefield_outdoors_hud.refresh_calculations()
    battlefield_outdoors_hud.character_info_panel.display_character(null)
    battlefield_outdoors_hud._enable_interaction(true)

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
    var excess_damage = _apply_combat_damage()
    if Database.war_transport_health_current > 0:
        war_transport.charge_followthrough(war_transport.global_position + Vector2(200, 0), duration)
        barrier.animate_destruction(duration)
        _apply_combat_rewards(floor(Database.current_barrier_data.cost_to_overcome), excess_damage)
        battlefield_outdoors_hud.set_combat_results(combat_result)
    else:
        battlefield_outdoors_hud.set_combat_results(combat_result)
        war_transport.hide_power(duration)
        war_transport.defeated_knockback(duration)


func _apply_combat_damage() -> int:
    var updated_health = Database.war_transport_health_current
    var player_strength = combat_math_formulas.total_dice_with_matching_stat_type_multiplier(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )
    var damage_amount = max(
        floor(Database.current_barrier_cost_to_overcome_number - player_strength),
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
    return player_strength - Database.current_barrier_data.cost_to_overcome

func _on_charge_cooldown(duration: float) -> void:
    war_transport.hide_power(duration)
    
    _generate_and_scale_next_barrier()
    
    if Database.current_distance_remaining > 0:
        Database.clear_all_frozen_status()
        battlefield_outdoors_hud.request_roll_preview_start()

        const scrolling_duration = ChargeSequence.COOLDOWN_DURATION + 2
        war_transport.return_to_start_position(scrolling_duration)
        camera_focus_moving.emit(Vector2(400, 0), scrolling_duration)
        barrier.new_barrier_scroll_onscreen(scrolling_duration, Vector2(400, 0))

        if checkpoint_reached:
            milestone_achieved.emit()

    # victory handling
    else:
        _on_victory()

func _on_charge_finish() -> void:
    battlefield_outdoors_hud.request_roll_preview_stop()
    const free_reroll_cost = 0
    _on_roll_requested(free_reroll_cost)

    if checkpoint_reached:
        _save_checkpoint()
        

    combat_result.clear()

func _generate_and_scale_next_barrier() -> void:
    var base_value: float = Database.current_region_starting_barrier_strength
    var barrier_count: int = Database.barrier_count_in_this_region + 1
    var scale_amount: float = Database.barriers_linear_scale_amount
    var variance: float = Database.current_region.barrier_variance
    var new_barrier: BarrierData = _generate_barrier_data(base_value, barrier_count, scale_amount,
        variance)

    Database.set_barrier_count_in_this_region(barrier_count)

    if new_barrier.cost_to_overcome != Database.current_barrier_cost_to_overcome_number:
        Database.set_current_barrier_cost_to_overcome_number(new_barrier.cost_to_overcome)
    if Database.current_barrier_stat_type_to_overcome != new_barrier.weakness_type:
        Database.set_current_barrier_stat_type_to_overcome(new_barrier.weakness_type)

    Database.set_current_barrier_data(new_barrier)

func _generate_barrier_data(base_value: float, barrier_count: int, scale_amount: float,
        variance: float) -> BarrierData:
    var cost_to_overcome = base_value + barrier_count * scale_amount
    cost_to_overcome += randf_range(-variance, variance)

    var random_display_name = BarrierData._get_random_display_name()
    var random_stat_type = Database.pick_barrier_type_from_region()
    
    return BarrierData.new(random_display_name, random_stat_type,
        cost_to_overcome)

func _apply_combat_rewards(barrier_health: int = 1, excess_power: int = 0) -> void:
    var region: Region = Database.current_region

    var distance_change = Database.DISTANCE_PER_BARRIER
    var distance_bonus = clamp((excess_power as float / barrier_health) + 1, .5, 2)
    distance_change = floor(distance_bonus * distance_change)
    distance_change += (randi() % (Database.DISTANCE_VARIANCE_RANGE * 2)) - Database.DISTANCE_VARIANCE_RANGE

    var money_change = region.money_reward + randi_range(-region.money_variance, region.money_variance)
    var fuel_change = region.fuel_reward + randi_range(-region.fuel_variance, region.fuel_variance)

    combat_result.distance_change = distance_change
    combat_result.money_change = money_change
    combat_result.fuel_change = fuel_change

    Database.set_current_distance_remaining(Database.current_distance_remaining - distance_change)
    Database.set_money(Database.current_money + money_change)
    Database.set_fuel(Database.current_fuel + fuel_change)
    Database.set_barriers_overcome_count(
        Database.barriers_overcome_count
        + 1
    )

func _save_checkpoint() -> void:
    checkpoint_reached = false
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

func _on_victory() -> void:
    const victory_sequence_duration: float = 2

    if charge_sequence_tween != null and charge_sequence_tween.is_valid():
        charge_sequence_tween.stop()
        charge_sequence_tween.kill()
    
    war_transport.continue_offscreen(victory_sequence_duration)

    victory.emit(victory_sequence_duration)
    
func _on_roll_requested(override_cost: int = -1):
    var roll_cost: int = override_cost if override_cost >= 0 else Database.current_reroll_fuel_cost
    if _has_unlocked_crew(Database.current_character_die_slots) and _has_enough_fuel(roll_cost):
        dice_roll_started.emit()
        Database.set_fuel(Database.current_fuel - roll_cost)
        _roll_dice()

func _has_enough_fuel(cost: int) -> bool:
    var enough_fuel: bool = Database.current_fuel >= cost
    if not enough_fuel:
        insufficient_fuel.emit()
    return enough_fuel

func _has_unlocked_crew(dice_slots: Array[CharacterDieSlot]):
    var all_dice_frozen: bool = dice_slots.all(
        func(character_die_slot: CharacterDieSlot) -> bool: return (
            character_die_slot.is_frozen
        )
    )
    if all_dice_frozen:
        all_locked.emit()
    return not all_dice_frozen

func _roll_dice() -> void:
    var character_die_slots = Database.current_character_die_slots
    for i: int in character_die_slots.size():
        var character_die_slot: CharacterDieSlot = character_die_slots[i]

        if character_die_slot.is_frozen:
            continue

        character_die_slot.last_roll_result = character_die_slot.roll_action()

    Database.set_current_character_die_slots(character_die_slots, true)
    battlefield_outdoors_hud.refresh_calculations()

func _on_checkpoint_saved() -> void:
    battlefield_outdoors_hud.screen_notification.queue_notification(
        ScreenNotification.ScreenNotificationType.CHECKPOINT,
        Database.CHECKPOINT_SAVED_MESSAGE,
        Database.CHECKPOINT_SAVED_DURATION
    )

func _on_new_applicants_arrived() -> void:
    battlefield_outdoors_hud.screen_notification.queue_notification(
        ScreenNotification.ScreenNotificationType.NOTIFY,
        ApplicantOrchestrator.NEW_APPLICANTS_MESSAGE % Database.applicants.size(),
        ApplicantOrchestrator.NEW_APPLICANTS_DURATION,
    )

func _on_region_changed(_new_region: Region, segment_info: ScenarioSegment) -> void:
    Database.set_war_transport_health_current(Database.war_transport_health_current + segment_info.arrival_bonus_heal)

    var base_value: float = Database.current_region_starting_barrier_strength
    var barrier_count: int = Database.barrier_count_in_this_region
    var scale_amount: float = Database.barriers_linear_scale_amount

    var new_starting_strength = base_value + barrier_count * scale_amount - segment_info.arrival_bonus_barrier_reduction

    Database.set_current_region_starting_barrier_strength(new_starting_strength)
    Database.set_barrier_count_in_this_region(0)
    Database.set_barriers_linear_scale_amount(_new_region.barrier_linear_scaling_amount)

    checkpoint_reached = true
