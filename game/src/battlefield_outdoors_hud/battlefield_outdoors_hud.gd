extends Control

@onready var health_current = $MarginContainer/HealthTrackerRow/HealthCurrent
@onready var health_maximum = $MarginContainer/HealthTrackerRow/HealthMaximum

func _ready():
	health_current.text = str(Database.war_transport_health_current)
	health_maximum.text = str(Database.war_transport_health_maximum)
