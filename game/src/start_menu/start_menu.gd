extends Control

@onready var quit_button = (
    $VBoxContainer/Buttons/ButtonRows/QuitButton
)


func _ready():
    if OS.get_name() == "Web":
        quit_button.visible = false


func _on_quit_button_pressed():
    get_tree().quit()


func _on_settings_button_pressed():
    get_tree().change_scene_to_file("res://src/settings_menu/SettingsMenu.tscn")

func _on_start_button_easy_pressed() -> void:
    Database.load_from_scenario(preload("res://assets/data/scenarios/easy_scenario.tres"))
    _start_game()
    
func _on_start_button_medium_pressed() -> void:
    Database.load_from_scenario(preload("res://assets/data/scenarios/difficult_scenario.tres"))
    _start_game()

func _on_start_button_hard_pressed() -> void:
    Database.load_from_scenario(preload("res://assets/data/scenarios/difficult_scenario.tres"))
    _start_game()

func _start_game():
    get_tree().change_scene_to_file("res://src/gameplay/Gameplay.tscn")
