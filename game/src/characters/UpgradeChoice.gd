class_name UpgradeChoice extends Resource

## Keys for the upgrade_funcs dictionary. Need one for every type of upgrade operation.
enum UpgradeType {
    REPLACE = 0,
    ADD = 1,
    UP_STAT = 2,
    REMOVE = 3,
    COPY = 4,
    COMBINE_MATCHES = 5,
    CHANGE_TYPE = 6,
    COMBINE_SPECIFIC = 7,
}

enum StatTypeCriteria {
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
    UpgradeType.COMBINE_MATCHES: _combine_matches,
    UpgradeType.CHANGE_TYPE: _change_type,
    UpgradeType.COMBINE_SPECIFIC: _combine_specific,
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
@export var filter_criteria: StatTypeCriteria = StatTypeCriteria.NONE
@export var invert_filter: bool = false
@export var sort_criteria: SortCriteria = SortCriteria.NONE
@export var number_of_actions_to_affect: int = 1
@export var change_to: StatTypeCriteria = StatTypeCriteria.NONE

@export var specific_combine_params: SpecificCombineParams

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
    var filtered_copy: Array[Action] = _filter_according_to_criteria(actions, upgrade.filter_criteria, upgrade.invert_filter)
    _get_slice_according_to_sort(filtered_copy, upgrade.sort_criteria, upgrade.number_of_actions_to_affect) \
        .map(_up.bind(upgrade.value_change_amount))

static func _change_type(upgrade: UpgradeChoice, action_selector: ActionSelector):
    var actions = action_selector.get_all()
    var filtered_copy: Array[Action] = _filter_according_to_criteria(actions, upgrade.filter_criteria, upgrade.invert_filter)
    _get_slice_according_to_sort(filtered_copy, upgrade.sort_criteria, upgrade.number_of_actions_to_affect) \
        .map(_change_to.bind(upgrade.change_to))

static func _remove(upgrade: UpgradeChoice, action_selector: ActionSelector):
    var actions = action_selector.get_all()
    var filtered_copy: Array[Action] = _filter_according_to_criteria(actions, upgrade.filter_criteria, upgrade.invert_filter)
    var actions_to_remove = _get_slice_according_to_sort(
        filtered_copy,
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

static func _combine_matches(_upgrade: UpgradeChoice, action_selector: ActionSelector):
    const min_matches: int = 2

    var actions = action_selector.get_all()
    var matches_dict: Dictionary = {}
    for action: Action in actions:
        if not matches_dict.has(action.name):
            matches_dict[action.name] = []
        matches_dict[action.name].append(action)
    
    for action_name: String in matches_dict.keys():
        var matching_actions: Array = matches_dict[action_name]
        while matching_actions.size() >= min_matches:
            _combine(matching_actions[0], matching_actions[1], action_selector)
            matching_actions.remove_at(1)
    
static func _combine_specific(upgrade: UpgradeChoice, action_selector: ActionSelector):
    var params: SpecificCombineParams = upgrade.specific_combine_params

    # get retain action
    var filtered_actions: Array[Action] = action_selector.get_all() 
    filtered_actions = _filter_according_to_criteria(filtered_actions, params.retain_filter, params.retain_invert_filter)
    var retain_action = _get_slice_according_to_sort(filtered_actions, params.retain_sort, 1)[0]
        
    filtered_actions = action_selector.get_all() 
    filtered_actions = _filter_according_to_criteria(filtered_actions, params.lost_filter, params.lost_invert_filter)
    var lost_action = _get_slice_according_to_sort(filtered_actions, params.lost_sort, 1)[0]

    _combine(retain_action, lost_action, action_selector)

## Helper methods

static func _up(action: Action, change_by: int):
    action.amount += change_by
    action.name = Action.generate_action_name(action.stat_type, action.amount)

static func _change_to(action: Action, new_type: Database.StatType):
    action.stat_type = new_type
    action.name = Action.generate_action_name(action.stat_type, action.amount)

static func _combine(retain_action: Action, lost_action: Action, action_selector: ActionSelector):
    _up(retain_action, lost_action.amount)
    action_selector.remove(lost_action.name)

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

static func _filter_according_to_criteria(actions: Array[Action], filter: StatTypeCriteria,
        invert: bool):
    if filter in Database.StatType.values():
        return actions.filter(
            func(x): return _match_stat(x, filter as Database.StatType) != invert
        )
    else:
        return actions.duplicate()

static func _sort_lowest(action1: Action, action2: Action):
    return action1.amount < action2.amount

static func _sort_highest(action1: Action, action2: Action):
    return action1.amount > action2.amount

## Helper Classes
