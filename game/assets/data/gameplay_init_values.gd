class_name GameplayInitValues extends Resource

@export_category("Progress")
@export var current_region_starting_barrier_strength: float
# Need to figure out if it's necessary to provide this as init value
var current_barrier_stat_type_to_overcome: Database.StatType = Database.StatType.MIGHT
var current_barrier_cost_to_overcome_number: float = 1
var barriers_linear_scale_amount: float = 1
var current_distance_remaining: int = 300
var barriers_overcome_count: int = 0
var current_barrier_data: BarrierData = null

@export_category("Mechanics")
@export var current_reroll_fuel_cost: int = 1
@export var current_matching_stat_type_multiplier: int = 2

@export_category("Player State")
@export var war_transport_health_maximum: int = 10
@export var war_transport_health_current: int = 10
@export var should_generate_new_applicants: bool = true
var current_character_die_slots: Array[CharacterDieSlot] = []

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

    current_matching_stat_type_multiplier = Database.current_matching_stat_type_multiplier
    war_transport_health_current = Database.war_transport_health_current
    war_transport_health_maximum = Database.war_transport_health_maximum
    should_generate_new_applicants = Database.should_generate_new_applicants

    hired_characters = deep_copy_character_array(Database.hired_characters)
    unhired_characters = deep_copy_character_array(Database.unhired_characters)
    applicants = deep_copy_character_array(Database.applicants)

    current_character_die_slots = deep_copy_die_slots(
        hired_characters,
        Database.current_character_die_slots
    )
    
    current_money = Database.current_money
    current_fuel = Database.current_fuel

func deep_copy_character_array(characters: Array[Character]) -> Array[Character]:
    var deep_copy_array: Array[Character] = []

    for character: Character in characters:
        deep_copy_array.append(character.deep_copy())

    return deep_copy_array

func deep_copy_die_slots(deep_copied_characters: Array[Character],
        die_slots: Array[CharacterDieSlot]
        ) -> Array[CharacterDieSlot]:
    var result: Array[CharacterDieSlot] = []

    for die_slot: CharacterDieSlot in die_slots:
        var new_character: Character
        new_character = deep_copied_characters.filter(func(x): return x.name == die_slot.character.name)[0]

        var new_action: Action
        new_action = new_character.actions.get_all().filter(func(x): return x.name == die_slot.last_roll_result.name)[0]

        var new_slot = CharacterDieSlot.new(new_character, die_slot.is_frozen)
        new_slot.last_roll_result = new_action

        result.append(new_slot)

    return result
