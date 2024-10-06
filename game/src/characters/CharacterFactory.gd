class_name CharacterFactory extends Resource

@export var name: String
@export_multiline var description: String
@export var portrait: Texture2D
@export var icon: Texture2D
@export var starting_action_strings: Array[String]
@export var upgrade_level: int
@export var upgrades: Array[UpgradeSelector]

func instantiate(hiring_cost: int = 10) -> Character:
    var starting_actions = _build_starting_actions()
    var action_selector = ActionSelector.new(starting_actions)
    return Character.new(
        name,
        description,
        portrait,
        icon,
        action_selector,
        upgrade_level,
        upgrades,
        hiring_cost
    )

func _build_starting_actions() -> Array[Action]:
    var starting_actions: Array[Action] = []
    for action_string: String in starting_action_strings:
        starting_actions.append(Action._parse_action_string(action_string))
    return starting_actions
