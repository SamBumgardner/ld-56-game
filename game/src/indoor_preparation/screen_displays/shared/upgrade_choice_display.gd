class_name UpgradeChoiceDisplay extends PanelContainer

@onready var upgrade_button_1: TextureButton = $HBoxContainer/TextureButton
@onready var or_label: Label = $HBoxContainer/Label
@onready var upgrade_button_2: TextureButton = $HBoxContainer/TextureButton2

func set_upgrade_choice_data(upgrade_selector: UpgradeSelector) -> void:
    upgrade_button_1.texture_normal = upgrade_selector.get_choice_data(0).icon_ref
    upgrade_button_2.texture_normal = upgrade_selector.get_choice_data(1).icon_ref
    for child in get_children():
        child.show()

func hide_upgrade_choice_info() -> void:
    for child in get_children():
        child.hide()
