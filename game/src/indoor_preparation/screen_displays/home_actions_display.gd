class_name HomeActionsDisplay extends CrewActionsDisplay

func _get_child_action_displays() -> Array[Node]:
    var result: Array[Node] = []
    result.append_array($ActionsRow1.get_children())
    result.append_array($ActionsRow2.get_children())
    return result
