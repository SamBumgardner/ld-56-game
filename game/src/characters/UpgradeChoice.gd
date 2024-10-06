class_name UpgradeChoice extends Resource

## Keys for the upgrade_funcs dictionary. Need one for every type of upgrade operation.
enum UpgradeType {
    REPLACE,
    ADD,
}

## Add methods to this dictionary keyed by their unique UpgradeType.
## This lets us translate an editor-set upgrade_type into a code action.
static var upgrade_funcs: Dictionary = {
    UpgradeType.REPLACE: _upgrade_replace,
    UpgradeType.ADD: _upgrade_add,
}

@export var name: String
@export_multiline var description: String
@export_multiline var visual_summary: String
@export var icon_ref: Texture2D
@export var cost: int

@export var upgrade_type: UpgradeType
@export var number_of_times: int = 1
@export var remove_action_name: String
@export var new_action_string: String

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
