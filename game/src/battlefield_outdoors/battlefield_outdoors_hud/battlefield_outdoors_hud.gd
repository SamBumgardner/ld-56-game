class_name BattlefieldOutdoorsHud extends Control

signal barrier_strength_scaled
signal dice_roll_requested

const REROLL_FAIL_MESSAGE = "Failed to shuffle unlocked actions.\nReason: INSUFFICIENT_FUEL"
const REROLL_FAIL_DURATION = 2

#@onready var barriers = $TopBar/Trackers/BarriersOvercomeTracker/Current
@onready var combat_math_formulas = CombatMathFormulas.new()
@onready var health_current = $TopBar/Trackers/HealthDisplay/MarginContainer/HBoxContainer/HealthCurrent
@onready var health_maximum = $TopBar/Trackers/HealthDisplay/MarginContainer/HBoxContainer/HealthMaximum
@onready var warning_only_frozen_troops = (
    $CentralControls/VBoxContainer/Warnings/WarningOnlyFrozenTroops
)
@onready var warning_out_of_health = (
    $CentralControls/VBoxContainer/Warnings/WarningOutOfHealth
)
@onready var warning_out_of_troops = (
    $CentralControls/VBoxContainer/Warnings/WarningOutOfTroops
)
@onready var screen_notification: ScreenNotification = $ScreenNotification
@onready var fuel_display: FuelDisplay = $TopBar/Trackers/FuelDisplay
@onready var bottom_bar_fuel: FuelDisplay = $BottomInfoDisplay/Center/TopEdge/FuelDisplayMini
@onready var calculations_hud: CombatMathCalculationsHud = $BottomInfoDisplay/Center/CrewStatus/StatusSections/CalculationsDisplay/CombatMathCalculationsHud


func _ready():
    _hide_warnings()

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


func _hide_warnings() -> void:
    warning_out_of_health.visible = false
    _hide_roll_warnings()


func _hide_roll_warnings() -> void:
    warning_only_frozen_troops.visible = false
    warning_out_of_troops.visible = false


func _on_mock_attack_button_pressed() -> void:
    _hide_roll_warnings()

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
        Database.set_fuel(Database.current_fuel + randi_range(1,3))
        _scale_up_barrier_strength()
        Database.set_barriers_overcome_count(
            Database.barriers_overcome_count
            + 1
        )
        #barriers.text = str(Database.barriers_overcome_count)
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

    if Database.current_character_die_slots.all(
        func(character_die_slot: CharacterDieSlot) -> bool: return (
            character_die_slot.is_frozen
        )
    ):
        print_debug('Player requested a roll with only frozen troops.')
        warning_only_frozen_troops.visible = true
        return

    # Player is rolling at least one character die.
    _hide_roll_warnings()

    dice_roll_requested.emit()
    calculations_hud.refresh()


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

func _on_insufficient_fuel() -> void:
    screen_notification.display_notification(
        ScreenNotification.ScreenNotificationType.ERROR,
        REROLL_FAIL_MESSAGE,
        REROLL_FAIL_DURATION
    )
    fuel_display._on_insufficient_resource()
    bottom_bar_fuel._on_insufficient_resource()
    
