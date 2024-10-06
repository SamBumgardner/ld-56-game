class_name CharacterDetail extends Control

@onready var database: Database = $/root/Database
@onready var character_summary: CharacterDetailSummary = $BasicSummary
@onready var upgrade_selection: CharacterDetailUpgrades = $UpgradeSelection
@onready var dynamic_info_panel: DynamicInfoPanel = $DynamicInfoPanel
@onready var character_icon: TextureRect = $IconAndCost/CharacterIcon
@onready var exit_button: Button = $ExitButton

var character: Character

func _ready() -> void:
    var connect_callables: Dictionary = upgrade_selection.get_all_upgrade_button_signal_connects()
    for connection: Callable in connect_callables["hovered"]:
        connection.call(dynamic_info_panel.preview_upgrade_data)
    for connection: Callable in connect_callables["selected"]:
        connection.call(dynamic_info_panel.select_upgrade_data)
    for connection: Callable in connect_callables["exited"]:
        connection.call(dynamic_info_panel.stop_previewing_upgrade_data)

func set_character_data(new_character: Character):
    character_summary.set_character_data(new_character)
    upgrade_selection.set_character_data(new_character)
    character_icon.texture = new_character.icon
    character = new_character

func exited_display() -> void:
    upgrade_selection.unpress_all_upgrade_buttons()

func refresh_upgrade_display():
    upgrade_selection.set_character_data(character)
