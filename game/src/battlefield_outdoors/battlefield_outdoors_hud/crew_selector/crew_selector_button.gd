class_name CrewSelectorButton extends TextureRect

signal character_selected(character: Character, button_end_state: bool)

@onready var button: Button = $Button

var character: Character

func _ready() -> void:
    button.pressed.connect(_on_button_pressed)
    set_character(character)

func set_character(new_character: Character) -> void:
    character = new_character
    if character != null:
        texture = character.portrait
        show()
    else:
        hide()

func _on_button_pressed() -> void:
    character_selected.emit(character, button.button_pressed)

func disable() -> void:
    button.disabled = true

func enable() -> void:
    button.disabled = false
