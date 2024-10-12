class_name CharacterActionDisplay extends TextureRect

signal character_selected(character: Character, button_end_state: bool)


@onready var die_result: DieResult = $DieResult
@onready var frozen_background: Control = $FrozenBackground
@onready var frozen_icon: TextureRect = $FrozenIcon
@onready var button: Button = $Button

var character_die_slot: CharacterDieSlot

func _ready() -> void:
    button.gui_input.connect(_handle_freeze_roll_action)
    button.pressed.connect(_on_button_pressed)
    Database.die_slot_changed.connect(_on_die_slot_update)

func refresh() -> void:
    if character_die_slot != null:
        texture = character_die_slot.character.icon
        die_result.set_action(character_die_slot.last_roll_result)
        show()
        if character_die_slot.is_frozen:
            frozen_background.show()
            frozen_icon.show()
        else:
            frozen_background.hide()
            frozen_icon.hide()
    else:
        hide()


func set_character_die_slot(new_die_slot: CharacterDieSlot) -> void:
    character_die_slot = new_die_slot
    refresh()

func toggle_freeze() -> void:
    Database.set_die_slot_frozen_status(
        character_die_slot.character,
        not character_die_slot.is_frozen
    )

func _handle_freeze_roll_action(event: InputEvent):
    if event.is_action_pressed("freeze_roll"):
        toggle_freeze()
        get_viewport().set_input_as_handled()

func _on_button_pressed() -> void:
    character_selected.emit(character_die_slot.character, button.button_pressed)

func _on_die_slot_update(changed_die_slot: CharacterDieSlot) -> void:
    if changed_die_slot == character_die_slot:
        refresh()
