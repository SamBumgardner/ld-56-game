# Show a freeze status label next to a populated die result.
extends HBoxContainer

@export var action: Action = null
@export var is_frozen: bool = false

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
