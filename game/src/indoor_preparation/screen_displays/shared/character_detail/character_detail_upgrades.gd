class_name CharacterDetailUpgrades extends Control

@onready var upgrade_choices: Array[Node] = $MarginContainer/VBoxContainer.get_children().slice(1)

func set_character_data(character: Character) -> void:
    for i in range(upgrade_choices.size()):
        if i < character.upgrades.size():
            upgrade_choices[i].set_upgrade_choice_data(character.upgrades[i])
            upgrade_choices[i].show()
        else:
            upgrade_choices[i].hide_upgrade_choice_info()
