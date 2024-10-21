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


func _on_tutorial_button_pressed() -> void:
    get_tree().change_scene_to_file("res://src/scenario_selection/tutorial_selection_menu.tscn")


func _on_scenario_button_pressed() -> void:
    get_tree().change_scene_to_file("res://src/scenario_selection/ScenarioSelectionMenu.tscn")
