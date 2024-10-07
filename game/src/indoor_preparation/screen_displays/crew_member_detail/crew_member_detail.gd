class_name CrewMemberDetail extends CharacterDetail

signal upgrade_purchase_pressed(character: Character, upgrade_choice: UpgradeChoice,
    level_idx: int, choice_idx: int)

@onready var upgrade_prompt: UpgradeCostPrompt = $IconAndCost/UpgradePrompt

func _ready() -> void:
    super()
    var connect_callables: Dictionary = upgrade_selection.get_all_upgrade_button_signal_connects()
    for connection: Callable in connect_callables["hovered"]:
        connection.call(upgrade_prompt.preview_upgrade_cost)
    for connection: Callable in connect_callables["selected"]:
        connection.call(upgrade_prompt.select_upgrade_cost)
    for connection: Callable in connect_callables["exited"]:
        connection.call(upgrade_prompt.stop_previewing_upgrade_cost)
    
    upgrade_prompt.upgrade_purchase_pressed.connect(_on_upgrade_button_pressed)


func _on_upgrade_button_pressed(upgrade_choice: UpgradeChoice):
    var upgrade_level: int = -1
    var choice_idx: int = -1
    for level_idx: int in range(character.upgrades.size()):
        choice_idx = character.upgrades[level_idx].choices.find(upgrade_choice)
        if choice_idx != -1:
            upgrade_level = level_idx
            break

    upgrade_purchase_pressed.emit(character, upgrade_choice, upgrade_level, choice_idx)

func refresh_upgrade_display():
    super()
    upgrade_prompt.clear_upgrade_data()
