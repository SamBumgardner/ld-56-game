class_name DynamicInfoPanel extends PanelContainer

const cost_format_string: String = "[right]Cost: [img=15%%]res://assets/art/ATTACK_icon_64x64.png[/img]%s"

@export var display_optional_cost_text: bool = true

@onready var upgrade_details_container: Control = $MarginContainer/VBoxContainer/Panel/MarginContainer/UpgradeDetailsContainer
@onready var upgrade_icons: Array[TextureRect] = [
    $MarginContainer/VBoxContainer/Panel/MarginContainer/UpgradeDetailsContainer/HBoxContainer/UpgradeIcon1,
    $MarginContainer/VBoxContainer/Panel/MarginContainer/UpgradeDetailsContainer/HBoxContainer/UpgradeIcon2
]
@onready var upgrade_name: Label = $MarginContainer/VBoxContainer/Panel/MarginContainer/UpgradeDetailsContainer/HBoxContainer/UpgradeName
@onready var upgrade_description: Label = $MarginContainer/VBoxContainer/Panel/MarginContainer/UpgradeDetailsContainer/UpgradeDescription
@onready var visual_summary: RichTextLabel = $MarginContainer/VBoxContainer/Panel/MarginContainer/UpgradeDetailsContainer/VisualSummary
@onready var no_information: Label = $MarginContainer/VBoxContainer/Panel/MarginContainer/NoInformation
@onready var optional_cost_info: RichTextLabel = $MarginContainer/VBoxContainer/Panel/MarginContainer/OptionalCostInfo

var selected_upgrade: UpgradeChoice
var previewed_upgrade: UpgradeChoice
var is_previewing: bool = false

func select_upgrade_data(upgrade_choice: UpgradeChoice):
    selected_upgrade = upgrade_choice
    update_display_elements()

func preview_upgrade_data(upgrade_choice: UpgradeChoice):
    is_previewing = true
    previewed_upgrade = upgrade_choice
    update_display_elements()

func stop_previewing_upgrade_data(_upgrade_choice: UpgradeChoice):
    previewed_upgrade = null
    is_previewing = false
    update_display_elements()

func update_display_elements():
    var upgrade_to_display: UpgradeChoice = selected_upgrade
    if is_previewing and selected_upgrade != previewed_upgrade:
        upgrade_details_container.modulate = Color(1, 1, 1, .5)
        optional_cost_info.modulate = Color(1, 1, 1, .5)
        upgrade_to_display = previewed_upgrade
    else:
        upgrade_details_container.modulate = Color.WHITE
        optional_cost_info.modulate = Color.WHITE
    
    if upgrade_to_display == null:
        upgrade_details_container.hide()
        optional_cost_info.hide()
        no_information.show()
    else:
        for texture_rect: TextureRect in upgrade_icons:
            texture_rect.texture = upgrade_to_display.icon_ref
        upgrade_name.text = upgrade_to_display.name
        upgrade_description.text = upgrade_to_display.description
        visual_summary.text = upgrade_to_display.visual_summary
        if display_optional_cost_text:
            optional_cost_info.text = cost_format_string % upgrade_to_display.cost
            optional_cost_info.show()
        else:
            optional_cost_info.hide()

        upgrade_details_container.show()
        no_information.hide()

func clear_upgrade_data():
    selected_upgrade = null
    previewed_upgrade = null
    update_display_elements()
