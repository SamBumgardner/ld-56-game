extends Control

@onready var health_current = $MarginContainer/HealthTrackerRow/HealthCurrent
@onready var health_maximum = $MarginContainer/HealthTrackerRow/HealthMaximum

var mock_damage_amount = 21


func _ready():
	_set_health_text()


func _on_mock_attack_button_pressed():
	Database.set_war_transport_health_current(
		Database.war_transport_health_current
		- mock_damage_amount
	)
	_set_health_text()

func _set_health_text():
	health_current.text = str(Database.war_transport_health_current)
	health_maximum.text = str(Database.war_transport_health_maximum)
