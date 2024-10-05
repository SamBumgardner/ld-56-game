class_name CharacterFactory extends Resource

@export var name: String
@export var description: String
@export var portrait: Texture2D
@export var icon: Texture2D
@export var starting_actions: Array[Action]
@export var upgrade_level: int
@export var upgrades: Array[UpgradeSelector]

func instantiate() -> Character:
    var action_selector = ActionSelector.new(starting_actions)
    return Character.new(
        name,
        description,
        portrait,
        icon,
        action_selector,
        upgrade_level,
        upgrades
    )