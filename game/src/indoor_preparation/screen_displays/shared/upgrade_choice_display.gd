class_name UpgradeChoiceDisplay extends PanelContainer

@onready var upgrade_button_1: Button = $HBoxContainer/Button
@onready var or_label: Label = $HBoxContainer/Label
@onready var upgrade_button_2: Button = $HBoxContainer/Button2

func set_upgrade_choice_data(upgrade_selector: UpgradeSelector) -> void:
    upgrade_button_1.icon = upgrade_selector.get_choice_data(0).icon_ref
    upgrade_button_2.icon = upgrade_selector.get_choice_data(1).icon_ref
    for child in get_children():
        child.show()

func hide_upgrade_choice_info() -> void:
    for child in get_children():
        child.hide()
