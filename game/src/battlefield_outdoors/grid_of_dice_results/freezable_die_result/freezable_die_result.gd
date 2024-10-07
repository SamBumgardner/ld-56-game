# Show a freeze status label next to a populated die result.
extends HBoxContainer

@export var action: Action = null
@export var is_frozen: bool = false
@export var current_character_die_slot_index: int

@onready var die_result = $DieResult
@onready var frozen_status_toggle = $FrozenStatusToggle


func _ready():
    set_action(action)


func set_action(incoming_action: Action) -> void:
    die_result.set_action(incoming_action)
    action = die_result.action
    _set_frozen_status_toggle()


func _build_frozen_status_label_text():
    if action == null:
        return ''

    if is_frozen:
        return 'Frozen'

    return 'Unfrozen'


func _set_frozen_status_toggle():
    var incoming_text = _build_frozen_status_label_text()
    frozen_status_toggle.text = incoming_text
    frozen_status_toggle.visible = incoming_text != ''


func _on_frozen_status_toggle_pressed():
    is_frozen = !is_frozen

    _set_frozen_status_toggle()

    if current_character_die_slot_index == null:
        print_debug(
            'Frozen die index is null, so ignore updating the database.'
        )
        return

    var updated_character_die_slots = Database.current_character_die_slots
    updated_character_die_slots[current_character_die_slot_index].is_frozen = (
        is_frozen
    )
    Database.set_current_character_die_slots(
        updated_character_die_slots
    )
