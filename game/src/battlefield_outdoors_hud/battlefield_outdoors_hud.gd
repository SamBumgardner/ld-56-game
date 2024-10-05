extends Control

@onready var health_current = $MarginContainer/HealthTrackerRow/HealthCurrent
@onready var health_maximum = $MarginContainer/HealthTrackerRow/HealthMaximum
@onready var warning_out_of_troops = (
	$MarginContainer2/VBoxContainer/WarningOutOfTroops
)

var mock_damage_amount = 21


func _ready():
	warning_out_of_troops.visible = false
	_set_health_text()


func _on_mock_attack_button_pressed():
	warning_out_of_troops.visible = false

	Database.set_war_transport_health_current(
		Database.war_transport_health_current
		- mock_damage_amount
	)
	_set_health_text()

func _set_health_text():
	health_current.text = str(Database.war_transport_health_current)
	health_maximum.text = str(Database.war_transport_health_maximum)


func _on_mock_reroll_button_pressed():
	print_debug('Player requested a roll without any troops.')
	warning_out_of_troops.visible = true
