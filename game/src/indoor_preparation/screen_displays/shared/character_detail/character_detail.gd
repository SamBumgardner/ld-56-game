class_name CharacterDetail extends Control

@onready var database: Database = $/root/Database
@onready var character_summary: CharacterDetailSummary = $BasicSummary
@onready var upgrade_selection: CharacterDetailUpgrades = $UpgradeSelection
@onready var character_icon: TextureRect = $IconAndCost/CharacterIcon
@onready var exit_button: Button = $ExitButton

func _ready() -> void:
    #if self == get_tree().current_scene:
        set_character_data(database.hired_characters[0])

func set_character_data(character: Character):
    character_summary.set_character_data(character)
    upgrade_selection.set_character_data(character)
    character_icon.texture = character.icon
