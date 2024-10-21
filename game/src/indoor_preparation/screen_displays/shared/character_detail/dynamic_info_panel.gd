class_name DynamicInfoPanel extends PanelContainer

const cost_format_string: String = "[right]Cost: [img=15%%]res://assets/art/tiny_silver_coin.png[/img]%s"
const already_purchased_string: String = "[right]Bought!"
const no_longer_available_string: String = "[right]Unavailable"

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
var selected_level_purchased: bool = false
var selected_upgrade_purchased: bool = false
var previewed_upgrade: UpgradeChoice
var is_previewing: bool = false

func select_upgrade_data(upgrade_choice: UpgradeChoice, upgrade_level_purchased: bool,
        this_purchased: bool):
    selected_upgrade = upgrade_choice
    selected_level_purchased = upgrade_level_purchased
    selected_upgrade_purchased = this_purchased
    update_display_elements(upgrade_level_purchased, this_purchased)

func preview_upgrade_data(upgrade_choice: UpgradeChoice, upgrade_level_purchased: bool,
        this_purchased: bool):
    is_previewing = true
    previewed_upgrade = upgrade_choice
    update_display_elements(upgrade_level_purchased, this_purchased)

func stop_previewing_upgrade_data(_upgrade_choice: UpgradeChoice):
    previewed_upgrade = null
    is_previewing = false
    update_display_elements(selected_level_purchased, selected_upgrade_purchased)

func update_display_elements(level_purchased: bool, this_purchased: bool):
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
            if not level_purchased:
                optional_cost_info.text = cost_format_string % upgrade_to_display.cost
            elif this_purchased:
                optional_cost_info.text = already_purchased_string
            else:
                optional_cost_info.text = no_longer_available_string
            optional_cost_info.show()
        else:
            optional_cost_info.hide()

        upgrade_details_container.show()
        no_information.hide()

func clear_upgrade_data():
    selected_upgrade = null
    selected_level_purchased = false
    selected_upgrade_purchased = false
    previewed_upgrade = null
    update_display_elements(false, false)
