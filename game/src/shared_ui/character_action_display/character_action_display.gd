class_name CharacterActionDisplay extends TextureRect

@onready var die_result: DieResult = $DieResult
@onready var frozen_background: Control = $FrozenBackground
@onready var frozen_icon: TextureRect = $FrozenIcon
@onready var button: Button = $Button

var character_die_slot: CharacterDieSlot

func _ready() -> void:
    button.gui_input.connect(_handle_freeze_roll_action)

func set_character_die_slot(new_die_slot: CharacterDieSlot) -> void:
    character_die_slot = new_die_slot
    if character_die_slot != null:
        texture = character_die_slot.character.icon
        die_result.set_action(character_die_slot.last_roll_result)
        show()
    else:
        hide()

func toggle_freeze() -> void:
    character_die_slot.is_frozen = not character_die_slot.is_frozen
    if character_die_slot.is_frozen:
        frozen_background.show()
        frozen_icon.show()
    else:
        frozen_background.hide()
        frozen_icon.hide()

func _handle_freeze_roll_action(event: InputEvent):
    if event.is_action_pressed("freeze_roll"):
        toggle_freeze()
        get_viewport().set_input_as_handled()