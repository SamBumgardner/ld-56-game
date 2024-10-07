# Show a freeze status label next to a populated die result.
extends HBoxContainer

@export var action: Action = null
@export var is_frozen: bool = false

@onready var die_result = $DieResult
@onready var frozen_status_label = $FrozenStatusLabel


func _ready():
    set_action(action)


func set_action(action: Action) -> void:
    die_result.set_action(action)
    action = die_result.action
    _set_frozen_status_label()


func _build_frozen_status_label_text():
    if action == null:
        return ''

    if is_frozen:
        return 'Frozen'

    return 'Unfrozen'


func _set_frozen_status_label():
    frozen_status_label.text = _build_frozen_status_label_text()
