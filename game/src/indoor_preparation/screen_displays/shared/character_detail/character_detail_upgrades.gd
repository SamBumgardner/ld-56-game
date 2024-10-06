class_name CharacterDetailUpgrades extends Control

@onready var upgrade_choices: Array[Node] = $MarginContainer/VBoxContainer.get_children().slice(1)

func set_character_data(character: Character) -> void:
    for i in range(upgrade_choices.size()):
        if i < character.upgrades.size():
            upgrade_choices[i].set_upgrade_choice_data(character.upgrades[i],
                character.upgrade_choice_history[i])
            upgrade_choices[i].show()
        else:
            upgrade_choices[i].hide_upgrade_choice_info()
    unpress_all_upgrade_buttons()

func unpress_all_upgrade_buttons() -> void:
    for upgrade_choice in upgrade_choices:
        upgrade_choice.unpress_all_upgrade_buttons()

func get_all_upgrade_button_signal_connects() -> Dictionary:
    var result = {
        "hovered": [],
        "exited": [],
        "selected": [],
    }
    for upgrade_choice_display in upgrade_choices:
        result["hovered"].append(upgrade_choice_display.upgrade_hovered.connect)
        result["exited"].append(upgrade_choice_display.upgrade_exited.connect)
        result["selected"].append(upgrade_choice_display.upgrade_selected.connect)
    
    return result
