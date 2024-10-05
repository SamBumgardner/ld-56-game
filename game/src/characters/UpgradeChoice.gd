class_name UpgradeChoice extends Resource

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

enum UpgradeType {
    REPLACE_ONE,
}

func apply_changes(action_selector: ActionSelector) -> void:
    upgrade_funcs[upgrade_type].call(self, action_selector)

static func _upgrade_replace_one(upgrade: UpgradeChoice, action_selector: ActionSelector):
    action_selector.replace(upgrade.remove_action_name, upgrade.new_action)