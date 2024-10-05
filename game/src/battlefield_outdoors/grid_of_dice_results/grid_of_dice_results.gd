extends GridContainer

var character_die_slots: Array[CharacterDieSlot] = []

func _ready():
    character_die_slots = []

    for hired_character_index in Database.hired_characters.size():
        character_die_slots.append(
            CharacterDieSlot.new(
                Database.hired_characters[hired_character_index]
            )
        )

func roll_dice() -> void:
    for character_die_slot_index in character_die_slots.size():
        var character_die_slot: CharacterDieSlot = character_die_slots[
            character_die_slot_index
        ]

        if character_die_slot.is_frozen:
            continue

        character_die_slot.last_roll_result = character_die_slot.roll_action()

        get_child(character_die_slot_index).set_action(character_die_slot.last_roll_result)
