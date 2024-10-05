class_name ActionSelector extends RefCounted

var _actions: Array[Action]

func _init(__actions: Array[Action]) -> void:
    _actions = __actions

func roll_action() -> Action:
    return _actions.pick_random()

func append(new_action: Action):
    _actions.append(new_action)

func remove(action_name_to_remove: String):
    for action: Action in _actions:
        if action.name == action_name_to_remove:
            _actions.erase(action)
            break

func replace(action_name_to_remove: String, new_action: Action):
    remove(action_name_to_remove)
    append(new_action)

func get_all() -> Array[Action]:
    return _actions.duplicate()