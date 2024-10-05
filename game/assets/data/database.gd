# Defines variables shared across scenes with the correct data types.
extends Node

enum StatType {
    MIGHT,
    WIT,
    CHAOS,
}

static var string_to_stat_type: Dictionary = {
    "might": StatType.MIGHT,
    "wit": StatType.WIT,
    "chaos": StatType.CHAOS,
}

static var stat_type_to_icon: Dictionary = {
    StatType.MIGHT: preload("res://assets/art/ATTACK_icon_64x64.png"),
    StatType.WIT: preload("res://assets/art/HEAL_icon_64x64.png"),
    StatType.CHAOS: preload("res://assets/art/MAGIC_icon_64x64.png"),
}

const _initial_barriers_linear_scale_amount: int = 1
const _initial_barriers_stat_type_to_overcome: StatType = StatType.MIGHT
const _initial_barriers_overcome_count: int = 0
const _initial_barriers_cost_to_overcome_number: int = 0
const _initial_character_die_slots: Array[CharacterDieSlot] = []
const _initial_matching_stat_type_multiplier: int = 2
const _initial_war_transport_health_maximum: int = 10

const _character_factories: Array[CharacterFactory] = [
    preload("res://assets/data/characters/001_mouse_char.tres"),
    preload("res://assets/data/characters/002_lizard_char.tres"),
]

var barriers_overcome_count: int
var barriers_linear_scale_amount: int
var current_barrier_stat_type_to_overcome: StatType
var current_barrier_cost_to_overcome_number: int
var current_character_die_slots: Array[CharacterDieSlot]
var current_matching_stat_type_multiplier: int
var war_transport_health_current: int
var war_transport_health_maximum: int
var hired_characters: Array[Character]

func _ready():
    debug_initialize_characters()
    reset_values()
    
    # validate that characters were created & that they can roll actions.
    print(hired_characters)
    for character in hired_characters:
        print(character.roll_action().name)

func reset_values() -> void:
    set_barriers_overcome_count(_initial_barriers_overcome_count)
    set_barriers_linear_scale_amount(_initial_barriers_linear_scale_amount)
    set_current_barrier_cost_to_overcome_number(
        _initial_barriers_cost_to_overcome_number
    )
    set_current_barrier_stat_type_to_overcome(
        _initial_barriers_stat_type_to_overcome
    )
    set_current_character_die_slots(_initial_character_die_slots)
    set_current_matching_stat_type_multiplier(
        _initial_matching_stat_type_multiplier
    )
    set_war_transport_health_maximum(_initial_war_transport_health_maximum)

    set_war_transport_health_to_maximum()

#region Setters

func debug_initialize_characters() -> void:
    hired_characters = []
    for factory: CharacterFactory in _character_factories:
        hired_characters.append(factory.instantiate())

func set_barriers_linear_scale_amount(updated_number: int) -> void:
    barriers_linear_scale_amount = updated_number

func set_barriers_overcome_count(updated_count: int) -> void:
    barriers_overcome_count = updated_count

func set_current_barrier_stat_type_to_overcome(updated_stat_type: StatType) -> void:
    current_barrier_stat_type_to_overcome = updated_stat_type

func set_current_barrier_cost_to_overcome_number(updated_number: int) -> void:
    current_barrier_cost_to_overcome_number = updated_number

func set_current_character_die_slots(
    updated_slots: Array[CharacterDieSlot]
) -> void:
    current_character_die_slots = updated_slots

func set_current_matching_stat_type_multiplier(updated_number: int) -> void:
    current_matching_stat_type_multiplier = updated_number

func set_war_transport_health_current(updated_health: int) -> void:
    war_transport_health_current = updated_health

func set_war_transport_health_maximum(updated_health: int) -> void:
    war_transport_health_maximum = updated_health

func set_war_transport_health_to_maximum() -> void:
    set_war_transport_health_current(_initial_war_transport_health_maximum)

#endregion Setters
