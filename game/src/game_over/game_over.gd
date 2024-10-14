class_name GameOver extends ColorRect

@onready var title_container: Control = $TitleContainer
@onready var stats_container: Control = $StatsContainer
@onready var button_container: Control = $ButtonContainer
@onready var retry_button: Button = $ButtonContainer/Retry
@onready var main_menu_button: Button = $ButtonContainer/ToMainMenu

func _ready() -> void:
    retry_button.pressed.connect(_on_retry_pressed)
    main_menu_button.pressed.connect(_on_main_menu_pressed)
    
    _start_fade_in_sequence()
    
func _start_fade_in_sequence() -> void:
    const delay_duration: float = .5
    const fade_duration: float = .5
    var fade_in_sequence: Tween = create_tween()

    var children = get_children()
    for child in children:
        child.hide()
        child.modulate = Color.TRANSPARENT
        fade_in_sequence.tween_interval(delay_duration)
        fade_in_sequence.tween_callback(child.show)
        fade_in_sequence.tween_property(child, "modulate", Color.WHITE, fade_duration)

func _on_main_menu_pressed() -> void:
    get_tree().change_scene_to_packed(preload("res://src/start_menu/StartMenu.tscn"))

func _on_retry_pressed() -> void:
    # initalize the gameplay scene with appropriate "retry" parameters to start from last checkpoint.
    get_tree().change_scene_to_file("res://src/gameplay/Gameplay.tscn")
