class_name UpgradeCostPrompt extends Node

@onready var cost_display: RichTextLabel = $MarginContainer/VBoxContainer/CostDisplay
@onready var purchase_button: Button = $MarginContainer/VBoxContainer/PurchaseButton

var empty_cost_message = "[center]Upgrade\nCost:\n "
var cost_format_string = "[center]Upgrade\nCost:\n[img=15%%]res://assets/art/ATTACK_icon_64x64.png[/img]%s"

var selected_upgrade: UpgradeChoice
var previewed_upgrade: UpgradeChoice
var is_previewing: bool = false

func _ready() -> void:
    update_display_elements()

func select_upgrade_cost(upgrade_choice: UpgradeChoice):
    selected_upgrade = upgrade_choice
    update_display_elements()

func preview_upgrade_cost(upgrade_choice: UpgradeChoice):
    is_previewing = true
    previewed_upgrade = upgrade_choice
    update_display_elements()

func stop_previewing_upgrade_cost(_upgrade_choice: UpgradeChoice):
    previewed_upgrade = null
    is_previewing = false
    update_display_elements()

func update_display_elements():
    var upgrade_to_display: UpgradeChoice = selected_upgrade
    if is_previewing and selected_upgrade != previewed_upgrade:
        cost_display.modulate = Color(1, 1, 1, .5)
        upgrade_to_display = previewed_upgrade
    else:
        cost_display.modulate = Color.WHITE
    
    if upgrade_to_display == null:
        cost_display.text = empty_cost_message
    else:
        cost_display.text = cost_format_string % upgrade_to_display.cost

    if selected_upgrade == null:
        cost_display.modulate = Color(1, 1, 1, .5)
        purchase_button.disabled = true
    else:
        purchase_button.disabled = false

func clear_upgrade_data():
    selected_upgrade = null
    previewed_upgrade = null
    update_display_elements()
