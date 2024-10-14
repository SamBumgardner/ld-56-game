extends Control

@onready var quit_button = (
    $VBoxContainer/Buttons/ButtonRows/QuitButton
)


func _ready():
    Database.reset_values()
    if OS.get_name() == "Web":
        quit_button.visible = false


func _on_quit_button_pressed():
    get_tree().quit()


func _on_settings_button_pressed():
    get_tree().change_scene_to_file("res://src/settings_menu/SettingsMenu.tscn")


func _on_start_button_pressed():
    Database.reset_values()

    get_tree().change_scene_to_file("res://src/gameplay/Gameplay.tscn")
