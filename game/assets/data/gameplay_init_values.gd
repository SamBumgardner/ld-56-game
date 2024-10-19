class_name GameplayInitValues extends Resource

@export_category("Progress")
@export var current_distance_remaining: int
@export var barriers_overcome_count: int
@export var barriers_linear_scale_amount: int
@export var current_barrier_stat_type_to_overcome: Database.StatType
@export var current_barrier_cost_to_overcome_number: int
@export var current_region_starting_barrier_strength: int
# Need to figure out if it's necessary to provide this as init value
var current_barrier_data: BarrierData

@export_category("Mechanics")
@export var current_reroll_fuel_cost: int = 1
@export var current_matching_stat_type_multiplier: int = 2

@export_category("Player State")
@export var current_character_die_slots: Array[CharacterDieSlot] = []
@export var war_transport_health_current: int
@export var war_transport_health_maximum: int
@export var should_generate_new_applicants: bool

# Only needed when loading a save
var hired_characters: Array[Character]
var unhired_characters: Array[Character]
var applicants: Array[Character]

@export_category("Resources")
@export var current_money: int
@export var current_fuel: int

func _init(load_from_db: bool = false):
    if load_from_db:
        _load_from_db()

func _load_from_db():
    current_distance_remaining = Database.current_distance_remaining
    barriers_overcome_count = Database.barriers_overcome_count
    barriers_linear_scale_amount = Database.barriers_linear_scale_amount
    current_barrier_stat_type_to_overcome = Database.current_barrier_stat_type_to_overcome
    current_barrier_cost_to_overcome_number = Database.current_barrier_cost_to_overcome_number
    current_barrier_data = Database.current_barrier_data
    current_region_starting_barrier_strength = Database.current_region_starting_barrier_strength

    current_reroll_fuel_cost = Database.current_reroll_fuel_cost
    current_character_die_slots = Database.current_character_die_slots

    current_matching_stat_type_multiplier = Database.current_matching_stat_type_multiplier
    war_transport_health_current = Database.war_transport_health_current
    war_transport_health_maximum = Database.war_transport_health_maximum
    should_generate_new_applicants = Database.should_generate_new_applicants
    hired_characters = Database.hired_characters
    unhired_characters = Database.unhired_characters
    applicants = Database.applicants
    
    current_money = Database.current_money
    current_fuel = Database.current_fuel
