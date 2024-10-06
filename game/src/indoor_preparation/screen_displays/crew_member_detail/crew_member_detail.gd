class_name CrewMemberDetail extends CharacterDetail

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
