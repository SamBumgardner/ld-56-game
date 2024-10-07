class_name UpgradeCostPrompt extends Node

signal upgrade_purchase_pressed(upgrade_choice: UpgradeChoice)

@onready var cost_display: RichTextLabel = $MarginContainer/VBoxContainer/CostDisplay
@onready var purchase_button: Button = $MarginContainer/VBoxContainer/PurchaseButton

const already_purchased_string: String = "[center]Already\nPurchased!\n "
const not_available_string: String = "[center]Not\nAvailable\n "
const empty_cost_message = "[center]Upgrade\nCost:\n "
const cost_format_string = "[center]Upgrade\nCost:\n[img=15%%]res://assets/art/ATTACK_icon_64x64.png[/img]%s"

var selected_upgrade: UpgradeChoice
var selected_level_purchased: bool = false
var selected_upgrade_purchased: bool = false
var previewed_upgrade: UpgradeChoice
var is_previewing: bool = false

func _ready() -> void:
    purchase_button.pressed.connect(_on_purchase_button_pressed)
    update_display_elements(false, false)

func select_upgrade_cost(upgrade_choice: UpgradeChoice, level_purchased: bool,
        this_upgrade_purchased: bool):
    selected_upgrade = upgrade_choice
    selected_level_purchased = level_purchased
    selected_upgrade_purchased = this_upgrade_purchased
    update_display_elements(level_purchased, this_upgrade_purchased)

func preview_upgrade_cost(upgrade_choice: UpgradeChoice, level_purchased: bool,
        this_upgrade_purchased: bool):
    is_previewing = true
    previewed_upgrade = upgrade_choice
    update_display_elements(level_purchased, this_upgrade_purchased)

func stop_previewing_upgrade_cost(_upgrade_choice: UpgradeChoice):
    previewed_upgrade = null
    is_previewing = false
    update_display_elements(selected_level_purchased, selected_upgrade_purchased)

func update_display_elements(level_purchased: bool, this_upgrade_purchased: bool):
    var upgrade_to_display: UpgradeChoice = selected_upgrade
    if is_previewing and selected_upgrade != previewed_upgrade:
        cost_display.modulate = Color(1, 1, 1, .5)
        upgrade_to_display = previewed_upgrade
    else:
        cost_display.modulate = Color.WHITE
    
    if upgrade_to_display == null:
        cost_display.text = empty_cost_message
    else:
        if this_upgrade_purchased:
            cost_display.text = already_purchased_string
        elif level_purchased:
            cost_display.text = not_available_string
        else:
            cost_display.text = cost_format_string % upgrade_to_display.cost

    if selected_upgrade == null or level_purchased:
        cost_display.modulate = Color(1, 1, 1, .5)
        purchase_button.disabled = true
    else:
        purchase_button.disabled = false

func clear_upgrade_data():
    selected_upgrade = null
    selected_level_purchased = false
    selected_upgrade_purchased = false
    previewed_upgrade = null
    update_display_elements(false, false)

func _on_purchase_button_pressed():
    upgrade_purchase_pressed.emit(selected_upgrade)
