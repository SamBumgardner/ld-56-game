class_name UpgradeChoice extends Resource

## Keys for the upgrade_funcs dictionary. Need one for every type of upgrade operation.
enum UpgradeType {
    REPLACE,
    ADD,
    UP_RANDOM,
    UP_STAT,
    REMOVE,
}

enum SortCriteria {
    NONE,
    LOWEST,
    HIGHEST
}

## Add methods to this dictionary keyed by their unique UpgradeType.
## This lets us translate an editor-set upgrade_type into a code action.
static var upgrade_funcs: Dictionary = {
    UpgradeType.REPLACE: _upgrade_replace,
    UpgradeType.ADD: _upgrade_add,
    UpgradeType.UP_RANDOM: _upgrade_random_up,
    UpgradeType.UP_STAT: _up_stat,
    UpgradeType.REMOVE: _remove,
}

@export var name: String
@export_multiline var description: String
@export_multiline var visual_summary: String
@export var icon_ref: Texture2D
@export var cost: int
@export var additional_effect: UpgradeChoice

@export var upgrade_type: UpgradeType
@export var value_change_amount: int = 0
@export var number_of_times: int = 1
@export var remove_action_name: String
@export var new_action_string: String
@export var target_stat: Database.StatType
@export var sort_criteria: SortCriteria

func apply_changes(action_selector: ActionSelector) -> void:
    for i in range(number_of_times):
        upgrade_funcs[upgrade_type].call(self, action_selector)

## Example upgrade function. All others should have same signature so they can be used
## interchangeably.
static func _upgrade_replace(upgrade: UpgradeChoice, action_selector: ActionSelector):
    action_selector.replace(upgrade.remove_action_name,
        Action._parse_action_string(upgrade.new_action_string))

static func _upgrade_add(upgrade: UpgradeChoice, action_selector: ActionSelector):
    action_selector.append(Action._parse_action_string(upgrade.new_action_string))

static func _upgrade_random_up(upgrade: UpgradeChoice, action_selector: ActionSelector):
    _up(action_selector.get_all().pick_random(), upgrade.value_change_amount)

static func _up_stat(upgrade: UpgradeChoice, action_selector: ActionSelector):
    action_selector.get_all() \
        .filter(_match_stat.bind(upgrade.target_stat)) \
        .map(_up.bind(upgrade.value_change_amount))

static func _remove(upgrade: UpgradeChoice, action_selector: ActionSelector):
    var actions = action_selector.get_all()
    var actions_to_remove = _get_slice_according_to_sort(
        actions,
        upgrade.sort_criteria,
        upgrade.number_of_times)
    
    for item in actions_to_remove:
        actions.erase(item)

## Helper methods

static func _up(action: Action, change_by: int):
    action.amount += change_by

static func _match_stat(action: Action, stat: Database.StatType):
    return action.stat_type == stat

static func _get_slice_according_to_sort(
        actions: Array[Action],
        sort: SortCriteria,
        number_to_get: int):
    var temp_copy = actions.duplicate()

    match sort:
        SortCriteria.LOWEST:
            temp_copy.get_all().sort_custom(_sort_lowest)
        SortCriteria.HIGHEST:
            temp_copy.get_all().sort_custom(_sort_highest)
    
    return temp_copy.slice(0, number_to_get)


static func _sort_lowest(action1: Action, action2: Action):
    return action1.value > action2.value

static func _sort_highest(action1: Action, action2: Action):
    return action1.value < action2.value
