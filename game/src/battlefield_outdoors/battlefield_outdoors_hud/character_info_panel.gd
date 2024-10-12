class_name CharacterInfoPanel extends PanelContainer

const UPGRADE_FORMAT: String = "Upgrades:\n%s"

@onready var portrait: TextureRect = $MC/VB/Summary/Portrait
@onready var name_label: Label = $MC/VB/Summary/VB/Name
@onready var upgrade_label: Label = $MC/VB/Summary/VB/PC/MC/UpgradeLevel
@onready var possible_die_results: Array[Node] = $MC/VB/Actions/ActionsContainer.get_children()
@onready var current_die_result: DieResult = $MC/VB/CurrentAction/MC/HB/DieResult

func set_character(character: Character):
    portrait.texture = character.portrait
    name_label.text = character.name
    upgrade_label.text = UPGRADE_FORMAT % character.upgrade_level

    var possible_actions: Array[Action] = character.actions.get_all()
    for i: int in possible_die_results.size():
        var action: Action = null
        if i < possible_actions.size():
            action = possible_actions[i]
        possible_die_results[i].set_action(action)

    var character_die_slot: CharacterDieSlot = Database.get_die_slot_by_character(character)
    if character_die_slot != null:
        current_die_result.set_action(character_die_slot.last_roll_result)
    else:
        current_die_result.set_action(null)
