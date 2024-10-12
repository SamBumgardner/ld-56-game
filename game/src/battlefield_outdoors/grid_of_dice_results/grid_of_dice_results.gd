class_name GridOfDiceResults extends GridContainer

signal character_die_slots_rolled

var character_die_slots: Array[CharacterDieSlot] = []

var current_visible_count: int

# Should match `get_child_count()`.
var maximum_slots = 9

func _ready():
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


func _reveal_populated_die_slots() -> void:
    var visible_count = Database.current_character_die_slots.size()
    
    if visible_count == current_visible_count:
        return

    for character_die_slot_index in character_die_slots.size():
        get_child(character_die_slot_index).visible = (
            character_die_slot_index < visible_count
        )
