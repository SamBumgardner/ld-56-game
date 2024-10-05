extends GridContainer

var character_die_slots: Array[CharacterDieSlot] = []

# Should match `get_child_count()`.
var maximum_slots = 9

func _ready():
    _initialize_character_die_slots(Database.hired_characters)


func roll_dice() -> void:
    for character_die_slot_index in character_die_slots.size():
        if character_die_slot_index >= maximum_slots:
            print_debug(
                'Maximum die slots of ',
                maximum_slots,
                ' exceeded, stopping rolls.'
            )
            return

        var character_die_slot: CharacterDieSlot = character_die_slots[
            character_die_slot_index
        ]

        if character_die_slot.is_frozen:
            continue

        character_die_slot.last_roll_result = character_die_slot.roll_action()

        get_child(
            character_die_slot_index
        ).set_action(
            character_die_slot.last_roll_result
        )


func _initialize_character_die_slots(characters) -> void:
    character_die_slots = []

    for hired_character_index in characters.size():
        character_die_slots.append(
            CharacterDieSlot.new(
                characters[hired_character_index]
            )
        )
