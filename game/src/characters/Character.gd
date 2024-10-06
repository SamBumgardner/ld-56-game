class_name Character extends RefCounted

const UPGRADE_HISTORY_UNSET: int = -1

var name: String
var description: String
var portrait: Texture2D
var icon: Texture2D
var actions: ActionSelector
var upgrade_level: int
var upgrades: Array[UpgradeSelector]
var upgrade_choice_history: Array[int]
var hiring_cost: int

func _init(_name: String, _description: String, _portrait: Texture2D,
        _icon: Texture2D, _actions: ActionSelector, _upgrade_level: int,
        _upgrades: Array[UpgradeSelector], _hiring_cost: int) -> void:
    name = _name
    description = _description
    portrait = _portrait
    icon = _icon
    actions = _actions
    upgrade_level = _upgrade_level
    upgrades = _upgrades
    upgrade_choice_history = []
    for i: int in range(upgrades.size()):
        upgrade_choice_history.append(UPGRADE_HISTORY_UNSET)
    hiring_cost = _hiring_cost

func upgrade(level, choice_idx) -> void:
    var upgrade_to_apply: Callable = upgrades[level].get_upgrade_action(choice_idx)
    upgrade_to_apply.call(actions)
    while upgrade_choice_history.size() < level:
        push_warning("upgrade history not pre-filled, filling gap now")
        upgrade_choice_history.append(UPGRADE_HISTORY_UNSET)
    upgrade_choice_history[level] = choice_idx

func roll_action() -> Action:
    return actions.roll_action()
