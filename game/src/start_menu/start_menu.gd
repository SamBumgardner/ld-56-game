extends Control

@onready var quit_button = (
	$VBoxContainer/QuitButton
)


func _ready():
	if OS.get_name() == "Web":
		quit_button.visible = false


func _on_quit_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://src/gameplay/Gameplay.tscn")
