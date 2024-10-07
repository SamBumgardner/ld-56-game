extends Control

signal barrier_strength_scaled
signal dice_roll_requested

@onready var barriers = $TopBar/Trackers/BarriersOvercomeTracker/Current
@onready var combat_math_formulas = CombatMathFormulas.new()
@onready var health_current = $TopBar/Trackers/HealthTracker/HealthCurrent
@onready var health_maximum = $TopBar/Trackers/HealthTracker/HealthMaximum
@onready var warning_out_of_health = (
    $CentralControls/VBoxContainer/Warnings/WarningOutOfHealth
)
@onready var warning_out_of_troops = (
    $CentralControls/VBoxContainer/Warnings/WarningOutOfTroops
)


func _ready():
    warning_out_of_health.visible = false
    warning_out_of_troops.visible = false

    _set_health_text()

    Database.set_current_barrier_cost_to_overcome_number(
        Database.current_barrier_cost_to_overcome_number
        + Database.barriers_linear_scale_amount
    )
    barrier_strength_scaled.emit()


# Sum dice results, multiplying dice that match the target StatType.
func _get_war_transport_damage_reduction_amount() -> int:
    return combat_math_formulas.total_dice_with_matching_stat_type_multiplier(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )


func _on_mock_attack_button_pressed() -> void:
    warning_out_of_troops.visible = false

    if Database.war_transport_health_current <= 0:
        warning_out_of_health.visible = true
        return

    print_debug('War transport rams into the barrier.')

    var updated_health = Database.war_transport_health_current

    var war_transport_damage_reduction_amount = (
        _get_war_transport_damage_reduction_amount()
    )
    var damage_amount = (
        Database.current_barrier_cost_to_overcome_number
        - war_transport_damage_reduction_amount
    )

    if damage_amount > 0:
        _reduce_war_transport_health(damage_amount)

    if updated_health > 0:
        print_debug("*** EARNING MONEY **** Probably clean this up later.")
        Database.set_money(Database.current_money + randi_range(1, 100))
        _scale_up_barrier_strength()
        Database.set_barriers_overcome_count(
            Database.barriers_overcome_count
            + 1
        )
        barriers.text = str(Database.barriers_overcome_count)
        return

    print_debug('Game over, health has reached ', updated_health)
    warning_out_of_health.visible = true


func _on_mock_reroll_button_pressed() -> void:
    if Database.war_transport_health_current <= 0:
        print_debug('Player requested a roll without any health.')
        return

    if Database.hired_characters.size() == 0:
        print_debug('Player requested a roll without any troops.')
        warning_out_of_troops.visible = true
        return

    dice_roll_requested.emit()


func _reduce_war_transport_health(amount_to_subtract : int) -> int:
    var updated_health = (
        Database.war_transport_health_current
        - amount_to_subtract
    )
    Database.set_war_transport_health_current(
        updated_health
    )
    _set_health_text()
    return updated_health


func _scale_up_barrier_strength() -> void:
    print_debug('Database.current_barrier_cost_to_overcome_number: ',
        Database.current_barrier_cost_to_overcome_number)
    Database.set_current_barrier_cost_to_overcome_number(
        Database.current_barrier_cost_to_overcome_number
        + Database.barriers_linear_scale_amount
    )
    barrier_strength_scaled.emit()


func _set_health_text() -> void:
    health_current.text = str(Database.war_transport_health_current)
    health_maximum.text = str(Database.war_transport_health_maximum)
