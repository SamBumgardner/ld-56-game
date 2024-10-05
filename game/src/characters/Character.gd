class_name Character extends RefCounted

var name: String
var description: String
var portrait: Texture2D
var icon: Texture2D
var actions: ActionSelector
var upgrade_level: int
var upgrades: Array[UpgradeSelector]
var upgrade_choice_history: Array[int]

func upgrade(level, choice_idx) -> void:
    var upgrade_to_apply: Callable = upgrades[level].get_upgrade_action(choice_idx)
    upgrade_to_apply.call(actions)
    while upgrade_choice_history.size() < level:
        upgrade_choice_history.append(0)
    upgrade_choice_history[level] = choice_idx

func roll_action() -> Action:
    return actions.roll_action()