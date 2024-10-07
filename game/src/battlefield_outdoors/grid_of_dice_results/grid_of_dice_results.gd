class_name GridOfDiceResults extends GridContainer

signal character_die_slots_rolled

var character_die_slots: Array[CharacterDieSlot] = []

var current_visible_count: int

# Should match `get_child_count()`.
var maximum_slots = 9

func _ready():
    initialize_character_die_slots(Database.hired_characters)
    _reveal_populated_die_slots()


func roll_dice() -> void:
    for character_die_slot_index in character_die_slots.size():
        if character_die_slot_index >= maximum_slots:
            print_debug(
                'Maximum die slots of ',
                maximum_slots,
                ' exceeded, stopping rolls.'
            )
            break

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

    Database.set_current_character_die_slots(character_die_slots)

    _reveal_populated_die_slots()


func initialize_character_die_slots(characters) -> void:
    character_die_slots = []

    for hired_character_index in characters.size():
        var is_frozen = false
        if hired_character_index < Database.current_character_die_slots.size():
            is_frozen = Database.current_character_die_slots[hired_character_index].is_frozen
        character_die_slots.append(
            CharacterDieSlot.new(
                characters[hired_character_index],
                is_frozen
            )
        )

    Database.set_current_character_die_slots(character_die_slots)

    _add_sequential_indexes_to_children()


# Add indexes so children may freeze database die results.
func _add_sequential_indexes_to_children():
    for character_die_slot_index in character_die_slots.size():
        get_child(character_die_slot_index).current_character_die_slot_index = (
            character_die_slot_index
        )


func _reveal_populated_die_slots() -> void:
    var visible_count = Database.current_character_die_slots.size()
    
    if visible_count == current_visible_count:
        return

    for character_die_slot_index in character_die_slots.size():
        get_child(character_die_slot_index).visible = (
            character_die_slot_index < visible_count
        )
