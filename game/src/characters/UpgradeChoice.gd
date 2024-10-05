class_name UpgradeChoice extends Resource

## Keys for the upgrade_funcs dictionary. Need one for every type of upgrade operation.
enum UpgradeType {
    REPLACE_ONE,
}

## Add methods to this dictionary keyed by their unique UpgradeType.
## This lets us translate an editor-set upgrade_type into a code action.
static var upgrade_funcs: Dictionary = {
    UpgradeType.REPLACE_ONE: _upgrade_replace_one
}

@export var name: String
@export var description: String
@export var visual_summary: String
@export var icon_ref: Texture2D

@export var upgrade_type: UpgradeType
@export var remove_action_name: String
@export var new_action: Action

func apply_changes(action_selector: ActionSelector) -> void:
    upgrade_funcs[upgrade_type].call(self, action_selector)

## Example upgrade function. All others should have same signature so they can be used
## interchangeably.
static func _upgrade_replace_one(upgrade: UpgradeChoice, action_selector: ActionSelector):
    action_selector.replace(upgrade.remove_action_name, upgrade.new_action)