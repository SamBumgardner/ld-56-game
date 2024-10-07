class_name UpgradeChoiceDisplay extends PanelContainer

signal upgrade_hovered(upgrade: UpgradeChoice, upgrade_level_purchased: bool, this_purchased: bool)
signal upgrade_exited(upgrade: UpgradeChoice)
signal upgrade_selected(upgrade: UpgradeChoice, upgrade_level_purchased: bool, this_purchased: bool)

@onready var or_label: Label = $HBoxContainer/Label
@onready var upgrade_buttons: Array[Button] = [
    $HBoxContainer/Button,
    $HBoxContainer/Button2,
]
@onready var purchased_icons: Array[TextureRect] = [
    $HBoxContainer/Button/PurchasedIcon,
    $HBoxContainer/Button2/PurchasedIcon2
]
@onready var lock_panel: Node = $LockedPanel

var upgrades: Array[UpgradeChoice]
var upgrade_level_purchased: bool
var purchased_upgrade_idx: int

func _ready() -> void:
    for i in range(upgrade_buttons.size()):
        upgrade_buttons[i].connect("mouse_entered", _emit_decorated_hover.bind(i))
        upgrade_buttons[i].connect("mouse_exited", _emit_decorated_exit.bind(i))
        upgrade_buttons[i].connect("pressed", _emit_decorated_select.bind(i))

func resend_pressed_button():
    for button: Button in upgrade_buttons:
        if button.button_pressed:
            button.pressed.emit()

func set_upgrade_choice_data(upgrade_selector: UpgradeSelector, purchased_idx: int) -> void:
    purchased_upgrade_idx = purchased_idx
    upgrade_level_purchased = \
        purchased_idx in range(upgrade_selector.get_all_choice_data().size())
        
    upgrades = []
    for i in range(upgrade_buttons.size()):
        upgrades.append(upgrade_selector.get_choice_data(i))
        upgrade_buttons[i].icon = upgrades[i].icon_ref
        upgrade_buttons[i].self_modulate = Color.WHITE
        purchased_icons[i].hide()
        if upgrade_level_purchased:
            _set_button_display_purchased(i, purchased_idx)
    
    for child in get_children():
        child.show()

func _set_button_display_purchased(button_idx: int, purchased_idx: int) -> void:
    if button_idx != purchased_idx:
        upgrade_buttons[button_idx].self_modulate = Color.GRAY
    else:
        purchased_icons[button_idx].show()

func hide_upgrade_choice_info() -> void:
    for child in get_children():
        child.hide()

func unpress_all_upgrade_buttons() -> void:
    for button: Button in upgrade_buttons:
        button.button_pressed = false

func lock_display() -> void:
    lock_panel.show()

func unlock_display() -> void:
    lock_panel.hide()

func _emit_decorated_hover(button_idx: int) -> void:
    upgrade_hovered.emit(
        upgrades[button_idx] if button_idx < upgrades.size() else null,
        upgrade_level_purchased,
        purchased_upgrade_idx == button_idx)

func _emit_decorated_exit(button_idx: int) -> void:
    upgrade_exited.emit(upgrades[button_idx] if button_idx < upgrades.size() else null)

func _emit_decorated_select(button_idx: int) -> void:
    upgrade_selected.emit(upgrades[button_idx] if button_idx < upgrades.size() else null,
        upgrade_level_purchased,
        purchased_upgrade_idx == button_idx)
