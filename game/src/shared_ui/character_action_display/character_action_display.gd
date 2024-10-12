class_name CharacterActionDisplay extends TextureRect

@onready var die_result: DieResult = $DieResult

var character_die_slot: CharacterDieSlot

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
    # depending on result, we want to show this result as "locked" or "loose"
