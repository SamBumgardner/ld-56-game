class_name UpgradeChoice extends Resource

## Keys for the upgrade_funcs dictionary. Need one for every type of upgrade operation.
enum UpgradeType {
    REPLACE = 0,
    ADD = 1,
    UP_STAT = 2,
    REMOVE = 3,
    COPY = 4,
}

enum FilterCriteria {
    NONE = -1,
    MIGHT = Database.StatType.MIGHT,
    WIT = Database.StatType.WIT,
    CHAOS = Database.StatType.CHAOS,
}

enum SortCriteria {
    NONE = -1,
    LOWEST = 0,
    HIGHEST = 1,
    SHUFFLE = 2
}

## Add methods to this dictionary keyed by their unique UpgradeType.
## This lets us translate an editor-set upgrade_type into a code action.
static var upgrade_funcs: Dictionary = {
    UpgradeType.REPLACE: _upgrade_replace,
    UpgradeType.ADD: _upgrade_add,
    UpgradeType.UP_STAT: _up_stat,
    UpgradeType.REMOVE: _remove,
    UpgradeType.COPY: _copy,
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
@export var filter_criteria: FilterCriteria = FilterCriteria.NONE
@export var sort_criteria: SortCriteria = SortCriteria.NONE
@export var number_of_actions_to_affect: int = 1

func apply_changes(action_selector: ActionSelector) -> void:
    for i in range(number_of_times):
        upgrade_funcs[upgrade_type].call(self, action_selector)
    
    if additional_effect != null:
        additional_effect.apply_changes(action_selector)

## Example upgrade function. All others should have same signature so they can be used
## interchangeably.
static func _upgrade_replace(upgrade: UpgradeChoice, action_selector: ActionSelector):
    action_selector.replace(upgrade.remove_action_name,
        Action._parse_action_string(upgrade.new_action_string))

static func _upgrade_add(upgrade: UpgradeChoice, action_selector: ActionSelector):
    action_selector.append(Action._parse_action_string(upgrade.new_action_string))

static func _up_stat(upgrade: UpgradeChoice, action_selector: ActionSelector):
    var actions = action_selector.get_all()
    var filtered_copy: Array[Action] = _filter_according_to_criteria(actions, upgrade.filter_criteria)
    _get_slice_according_to_sort(filtered_copy, upgrade.sort_criteria, upgrade.number_of_actions_to_affect) \
        .map(_up.bind(upgrade.value_change_amount))

static func _remove(upgrade: UpgradeChoice, action_selector: ActionSelector):
    var actions = action_selector.get_all()
    var actions_to_remove = _get_slice_according_to_sort(
        actions,
        upgrade.sort_criteria,
        upgrade.number_of_actions_to_affect)
    
    for item in actions_to_remove:
        action_selector.remove(item.name)

static func _copy(upgrade: UpgradeChoice, action_selector: ActionSelector):
    var actions = action_selector.get_all()
    var actions_to_copy = _get_slice_according_to_sort(
        actions,
        upgrade.sort_criteria,
        upgrade.number_of_actions_to_affect)
    
    for item in actions_to_copy:
        action_selector.append(Action.new(item.name, item.stat_type, item.amount))

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
            temp_copy.sort_custom(_sort_lowest)
        SortCriteria.HIGHEST:
            temp_copy.sort_custom(_sort_highest)
        SortCriteria.SHUFFLE:
            temp_copy.shuffle()
    
    return temp_copy.slice(0, number_to_get)

static func _filter_according_to_criteria(actions: Array[Action], filter: FilterCriteria):
    if filter in Database.StatType.values():
        return actions.filter(_match_stat.bind(filter))
    else:
        return actions.duplicate()

static func _sort_lowest(action1: Action, action2: Action):
    return action1.amount < action2.amount

static func _sort_highest(action1: Action, action2: Action):
    return action1.amount > action2.amount
