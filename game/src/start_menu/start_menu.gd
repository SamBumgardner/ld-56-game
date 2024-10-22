extends Control

@onready var sub_title = $SubTitle
@onready var menu_contents = $VBoxContainer
@onready var intro_sequence = $IntroSequence
@onready var quit_button = (
    $VBoxContainer/Buttons/PanelContainer/MarginContainer/ButtonRows/QuitButton
)

static var intro_played_once: bool = false

func _ready():
    intro_sequence.show()
    
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


func _on_intro_sequence_intro_finished() -> void:
    if not intro_played_once:
        intro_played_once = true
        
        var tween: Tween = create_tween()
        menu_contents.modulate = Color.TRANSPARENT
        sub_title.modulate = Color.TRANSPARENT
        tween.tween_callback(sub_title.show)
        tween.tween_property(sub_title, "modulate", Color.WHITE, .5)
        tween.tween_callback(menu_contents.show)
        tween.tween_property(menu_contents, "modulate", Color.WHITE, .5)
    else:
        menu_contents.show()
        sub_title.show()
    
