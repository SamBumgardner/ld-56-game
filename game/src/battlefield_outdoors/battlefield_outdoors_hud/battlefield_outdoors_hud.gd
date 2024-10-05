extends Control

signal barrier_strength_scaled

@onready var barriers = $TopBar/Trackers/BarriersOvercomeTracker/Current
@onready var health_current = $TopBar/Trackers/HealthTracker/HealthCurrent
@onready var health_maximum = $TopBar/Trackers/HealthTracker/HealthMaximum
@onready var warning_out_of_health = (
    $CentralControls/VBoxContainer/Warnings/WarningOutOfHealth
)
@onready var warning_out_of_troops = (
    $CentralControls/VBoxContainer/Warnings/WarningOutOfTroops
)

var mock_initial_damage_amount = 21
var mock_scale_amount = 10


func _ready():
    warning_out_of_health.visible = false
    warning_out_of_troops.visible = false

    _set_health_text()

    Database.set_current_barrier_cost_to_overcome_number(
        mock_initial_damage_amount
    )


func _on_mock_attack_button_pressed() -> void:
    warning_out_of_troops.visible = false

    if Database.war_transport_health_current <= 0:
        warning_out_of_health.visible = true
        return

    print_debug('War transport rams into the barrier.')

    var updated_health = Database.war_transport_health_current

    var war_transport_damage_reduction_amount = 0
    var damage_amount = (
        Database.current_barrier_cost_to_overcome_number
        - war_transport_damage_reduction_amount
    )

    if damage_amount > 0:
        _reduce_war_transport_health(damage_amount)

    if updated_health > 0:
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
    print_debug('Player requested a roll without any troops.')
    warning_out_of_troops.visible = true


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
        + mock_scale_amount
    )
    barrier_strength_scaled.emit()


func _set_health_text() -> void:
    health_current.text = str(Database.war_transport_health_current)
    health_maximum.text = str(Database.war_transport_health_maximum)
