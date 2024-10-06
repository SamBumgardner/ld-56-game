class_name UpgradeChoiceDisplay extends PanelContainer

signal upgrade_hovered(upgrade: UpgradeChoice)
signal upgrade_exited(upgrade: UpgradeChoice)
signal upgrade_selected(upgrade: UpgradeChoice)

@onready var or_label: Label = $HBoxContainer/Label
@onready var upgrade_buttons: Array[Button] = [
    $HBoxContainer/Button,
    $HBoxContainer/Button2,
]

var upgrades: Array[UpgradeChoice]

func _ready() -> void:
    for i in range(upgrade_buttons.size()):
        upgrade_buttons[i].connect("mouse_entered", _emit_decorated_hover.bind(i))
        upgrade_buttons[i].connect("mouse_exited", _emit_decorated_exit.bind(i))
        upgrade_buttons[i].connect("pressed", _emit_decorated_select.bind(i))

func set_upgrade_choice_data(upgrade_selector: UpgradeSelector) -> void:
    upgrades = []
    for i in range(upgrade_buttons.size()):
        upgrades.append(upgrade_selector.get_choice_data(i))
        upgrade_buttons[i].icon = upgrades[i].icon_ref

    for child in get_children():
        child.show()

func hide_upgrade_choice_info() -> void:
    for child in get_children():
        child.hide()

func unpress_all_upgrade_buttons() -> void:
    for button: Button in upgrade_buttons:
        button.button_pressed = false

func _emit_decorated_hover(button_idx: int) -> void:
    upgrade_hovered.emit(upgrades[button_idx] if button_idx < upgrades.size() else null)

func _emit_decorated_exit(button_idx: int) -> void:
    upgrade_exited.emit(upgrades[button_idx] if button_idx < upgrades.size() else null)

func _emit_decorated_select(button_idx: int) -> void:
    upgrade_selected.emit(upgrades[button_idx] if button_idx < upgrades.size() else null)
