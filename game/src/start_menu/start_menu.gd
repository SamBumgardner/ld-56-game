extends Control

@onready var sub_title = $SubTitle
@onready var menu_contents = $VBoxContainer
@onready var intro_sequence = $IntroSequence
@onready var scenario_button: Button = (
    $VBoxContainer/Buttons/PanelContainer/MarginContainer/ButtonRows/ScenarioButton
)
@onready var settings_button: Button = (
    $VBoxContainer/Buttons/PanelContainer/MarginContainer/ButtonRows/SettingsButton
)
@onready var tutorial_button: Button = (
    $VBoxContainer/Buttons/PanelContainer/MarginContainer/ButtonRows/TutorialButton
)
@onready var quit_button = (
    $VBoxContainer/Buttons/PanelContainer/MarginContainer/ButtonRows/QuitButton
)

static var intro_played_once: bool = false

const animation_time_fade_in_sub_title_then_controls: float = .5
const animation_time_enable_controls_during_fade_in: float = .78

func _ready():
    intro_sequence.show()
    
    if not intro_played_once:
        _set_buttons_property_disabled(true)
    
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
        tween.tween_property(sub_title, "modulate", Color.WHITE, animation_time_fade_in_sub_title_then_controls)
        tween.tween_callback(menu_contents.show)
        tween.tween_property(menu_contents, "modulate", Color.WHITE, animation_time_fade_in_sub_title_then_controls)
        
        # Delay added here to let the controls fade in.
        create_tween() \
            .tween_callback(_set_buttons_property_disabled.bind(false)) \
            .set_delay(animation_time_enable_controls_during_fade_in)
    else:
        menu_contents.show()
        sub_title.show()
    
    # Grab focus on the tutorial button when the user waits through the
    #  intro animation.
    tutorial_button.grab_focus()


# Disable buttons while fading in intro animation.
func _set_buttons_property_disabled(is_disabled: bool) -> void:
    scenario_button.disabled = is_disabled
    settings_button.disabled = is_disabled
    tutorial_button.disabled = is_disabled
    quit_button.disabled = is_disabled
