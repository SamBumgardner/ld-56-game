class_name Region extends Resource

@export_category("Information")
@export var region_name: String = "Barren Lands"
@export_multiline var gameplay_description: String

@export_category("Barriers")
@export var barrier_linear_scaling_amount: int = 1
@export var barrier_variance: float = 3
@export var barrier_type_distribution: Array[Database.StatType] = [
    Database.StatType.MIGHT,
    Database.StatType.WIT,
    Database.StatType.CHAOS,
]

@export_category("Rewards")
@export var fuel_reward: int = 2
@export var fuel_variance: int = 1

@export var money_reward: int = 11
@export var money_variance: int = 3
