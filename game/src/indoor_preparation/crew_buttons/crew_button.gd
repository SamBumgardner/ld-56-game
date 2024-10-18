class_name CrewButton extends TextureButton

signal crew_member_selected(character: Character)
signal crew_member_hover_changed(character: Character, is_hovered: bool)
signal crew_member_deselected()

const FADE_IN_DURATION: float = 1

@export var character_factory: CharacterFactory

@onready var audio_manager: AudioManager = $AudioManager
@onready var database: Database = $"/root/Database"

@onready var original_texture_hovered: Texture2D = texture_hover
@onready var original_texture_normal: Texture2D = texture_normal

var character_hired: bool = false
var instantiated_character: Character
var fade_in_tween: Tween

func _ready() -> void:
    visibility_changed.connect(_on_visibility_changed)
    mouse_entered.connect(_on_button_hovered)
    mouse_exited.connect(_on_button_hovered)
    visible = false
    focus_mode = FocusMode.FOCUS_NONE
    _on_initial_setup(database.hired_characters)

func _enable_button(character: Character) -> void:
    character_hired = true
    visible = true
    instantiated_character = character

func _on_initial_setup(starting_characters: Array[Character]) -> void:
    for character: Character in starting_characters:
        if character.name == character_factory.name:
            _enable_button(character)

func _on_new_character_hired(character: Character) -> void:
    if character.name == character_factory.name:
        _enable_button(character)

func _toggled(toggled_on: bool) -> void:
    if toggled_on:
        crew_member_selected.emit(instantiated_character)
    if not toggled_on:
        crew_member_deselected.emit()

func _on_view_canceled() -> void:
    button_pressed = false

func _on_visibility_changed():
    if visible:
        self_modulate = Color.TRANSPARENT
        if fade_in_tween != null and fade_in_tween.is_running():
            fade_in_tween.stop()
        fade_in_tween = create_tween()
        fade_in_tween.set_ease(Tween.EASE_OUT)
        fade_in_tween.set_trans(Tween.TRANS_CUBIC)
        fade_in_tween.tween_property(self, "self_modulate", Color.WHITE, FADE_IN_DURATION)

func mimic_hover_changed(mimic_hovered: bool):
    if mimic_hovered:
        texture_normal = original_texture_normal
    else:
        texture_normal = original_texture_hovered

func _on_button_hovered() -> void:
    if not is_hovered():
        audio_manager.on_enabled_button_mouse_entered()

    crew_member_hover_changed.emit(instantiated_character, is_hovered())
