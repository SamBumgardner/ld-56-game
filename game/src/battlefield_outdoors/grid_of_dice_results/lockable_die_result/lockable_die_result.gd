# Show a lock status label next to a populated die result.
extends HBoxContainer

@export var action: Action = null
@export var is_locked: bool = false

@onready var die_result = $DieResult
@onready var lock_status_label = $LockStatusLabel


func _ready():
    set_action(action)


func set_action(action: Action) -> void:
    die_result.set_action(action)
    action = die_result.action
    _set_lock_status_label()


func _build_lock_status_label_text():
    if action == null:
        return ''

    if is_locked:
        return 'Locked'

    return 'Unlocked'


func _set_lock_status_label():
    lock_status_label.text = _build_lock_status_label_text()
