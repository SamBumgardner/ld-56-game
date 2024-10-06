class_name HomeDisplay extends Control

signal view_applicants_button_pressed()

@onready var view_applicants_button: Button = $MarginContainer/Button

func _ready() -> void:
    view_applicants_button.pressed.connect(_propagate_applicants_button_pressed)

func _propagate_applicants_button_pressed():
    view_applicants_button_pressed.emit()
