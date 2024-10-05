extends Control

@onready var barriers = $TopBar/HBoxContainer/BarriersOvercomeTracker/Current
@onready var health_current = $TopBar/HBoxContainer/HealthTracker/HealthCurrent
@onready var health_maximum = $TopBar/HBoxContainer/HealthTracker/HealthMaximum
@onready var warning_out_of_troops = (
	$MarginContainer2/VBoxContainer/WarningOutOfTroops
)
@onready var warning_out_of_health = $MarginContainer2/VBoxContainer/WarningOutOfHealth

var mock_damage_amount = 21


func _ready():
	warning_out_of_health.visible = false
	warning_out_of_troops.visible = false
	_set_health_text()


func _on_mock_attack_button_pressed():
	warning_out_of_troops.visible = false

	if Database.war_transport_health_current <= 0:
		warning_out_of_health.visible = true
		return

	var updated_health = (
		Database.war_transport_health_current
		- mock_damage_amount
	)
	Database.set_war_transport_health_current(
		updated_health
	)
	_set_health_text()

	if updated_health > 0:
		Database.set_barriers_overcome_count(
			Database.barriers_overcome_count
			+ 1
		)
		barriers.text = str(Database.barriers_overcome_count)
		return

	print_debug('Game over, health has reached ', updated_health)
	warning_out_of_health.visible = true

func _set_health_text():
	health_current.text = str(Database.war_transport_health_current)
	health_maximum.text = str(Database.war_transport_health_maximum)


func _on_mock_reroll_button_pressed():
	print_debug('Player requested a roll without any troops.')
	warning_out_of_troops.visible = true
