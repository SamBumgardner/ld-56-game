class_name Character extends RefCounted

const UPGRADE_HISTORY_UNSET: int = -1

var name: String
var description: String
var portrait: Texture2D
var icon: Texture2D
var actions: ActionSelector
var sfx_hello: AudioStream
var upgrade_level: int
var upgrades: Array[UpgradeSelector]
var upgrade_choice_history: Array[int]
var hiring_cost: int

func _init(_name: String, _description: String, _portrait: Texture2D,
        _icon: Texture2D, _actions: ActionSelector, _upgrade_level: int,
        _upgrades: Array[UpgradeSelector], _hiring_cost: int,
        _sfx_hello: AudioStream) -> void:
    name = _name
    description = _description
    portrait = _portrait
    icon = _icon
    actions = _actions
    upgrade_level = _upgrade_level
    upgrades = _upgrades
    for i: int in upgrades.size():
        for upgrade_choice: UpgradeChoice in upgrades[i].choices:
            if upgrade_choice.cost == 0:
                upgrade_choice.cost = Database.UPGRADE_DEFAULT_TIER_COSTS[i]
    upgrade_choice_history = []
    for i: int in range(upgrades.size()):
        upgrade_choice_history.append(-1)
    hiring_cost = _hiring_cost
    sfx_hello = _sfx_hello

func deep_copy() -> Character:
    var current_actions = actions.get_all()
    var new_actions: Array[Action] = []
    for action in current_actions:
        new_actions.append(Action._parse_action_string(action.name))
    var new_action_selector = ActionSelector.new(new_actions)
    
    var copy: Character = Character.new(name, description, portrait, icon, new_action_selector,
        upgrade_level, upgrades, hiring_cost, sfx_hello)
    
    copy.upgrade_choice_history = upgrade_choice_history.duplicate()

    return copy

func upgrade(level, choice_idx) -> void:
    var upgrade_to_apply: Callable = upgrades[level].get_upgrade_action(choice_idx)
    upgrade_to_apply.call(actions)
    while upgrade_choice_history.size() < level:
        push_warning("upgrade history not pre-filled, filling gap now")
        upgrade_choice_history.append(UPGRADE_HISTORY_UNSET)
    upgrade_choice_history[level] = choice_idx
    upgrade_level = level + 1

func roll_action() -> Action:
    return actions.roll_action()
