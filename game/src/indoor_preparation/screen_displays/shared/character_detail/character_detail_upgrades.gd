class_name CharacterDetailUpgrades extends Control

@onready var upgrade_choices: Array[Node] = $MarginContainer/VBoxContainer.get_children().slice(1)
var character: Character

func set_character_data(new_character: Character) -> void:
    character = new_character
    refresh_display_while_retaining_pressed()
    unpress_all_upgrade_buttons()

func refresh_and_resend_pushed_button_info() -> void:
    refresh_display_while_retaining_pressed()
    for upgrade_choice in upgrade_choices:
        upgrade_choice.resend_pressed_button()

func refresh_display_while_retaining_pressed() -> void:
    for i in range(upgrade_choices.size()):
        if i < character.upgrades.size():
            upgrade_choices[i].set_upgrade_choice_data(character.upgrades[i],
                character.upgrade_choice_history[i])
            upgrade_choices[i].show()
            if i > character.upgrade_level:
                upgrade_choices[i].lock_display()
            else:
                upgrade_choices[i].unlock_display()
        else:
            upgrade_choices[i].hide_upgrade_choice_info()

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
