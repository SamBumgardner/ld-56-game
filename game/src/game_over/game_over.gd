class_name GameOver extends TextureRect

const SCENARIO_FORMAT: String = "Scenario: %s"

@export var initial_delay: float = 0
@export var delay_duration: float = .5
@export var fade_duration: float = .5

@onready var audio_manager: AudioManager = $AudioManager
@onready var title_container: Control = $Control/TitleContainer
@onready var stats_container: Control = $Control/StatsContainer
@onready var button_container: Control = $Control/ButtonContainer
@onready var retry_button: Button = $Control/ButtonContainer/Retry
@onready var main_menu_button: Button = $Control/ButtonContainer/ToMainMenu
@onready var scenario_name: Label = $Control/TitleContainer/MarginContainer/HB/ScenarioName

func _ready() -> void:
    retry_button.pressed.connect(_on_retry_pressed)
    main_menu_button.pressed.connect(_on_main_menu_pressed)
    
    scenario_name.text = SCENARIO_FORMAT % Database.scenario.scenario_name
    
    if Database.saved_state == null:
        retry_button.disabled = true
    
    _start_fade_in_sequence()
    
func _start_fade_in_sequence() -> Tween:
    var fade_in_sequence: Tween = create_tween()
    fade_in_sequence.tween_interval(initial_delay)
    fade_in_sequence.tween_callback(_darken_background)

    var children = [
        title_container,
        stats_container,
        button_container
    ]
    for child in children:
        _append_fade_in_steps(child, fade_in_sequence)
    
    return fade_in_sequence

func _append_fade_in_steps(node: Node, tween: Tween):
    node.hide()
    node.modulate = Color.TRANSPARENT
    tween.tween_interval(delay_duration)
    tween.tween_callback(node.show)
    tween.tween_property(node, "modulate", Color.WHITE, fade_duration)

func _darken_background() -> void:
    var background_tween = create_tween()
    background_tween.tween_property(self, "self_modulate", Color(.4, .4, .4), fade_duration * 1.5)

func _on_main_menu_pressed() -> void:
    get_tree().change_scene_to_packed(preload("res://src/start_menu/StartMenu.tscn"))

func _on_retry_pressed() -> void:
    # initalize the gameplay scene with appropriate "retry" parameters to start from last checkpoint.
    if Database.saved_state != null:
        Database.load_from_init_values(Database.saved_state)
    else:
        Database.load_from_scenario(Database.scenario)
    get_tree().change_scene_to_file("res://src/gameplay/Gameplay.tscn")


#region Descendant SFX: enabled button mouse entered

func _on_retry_mouse_entered():
    if retry_button.disabled:
        return

    audio_manager.on_enabled_button_mouse_entered()

#endregion Descendant SFX: enabled button mouse entered
