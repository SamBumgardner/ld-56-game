extends HBoxContainer

@export var action: Action = null


func _ready():
    set_action(action)


func set_action(action: Action) -> void:
    if action == null:
        visible = false
        return

    $Amount.text = action.amount
