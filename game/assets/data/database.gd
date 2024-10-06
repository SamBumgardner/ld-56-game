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

const _initial_barriers_overcome_count: int = 0
const _initial_character_die_slots: Array[CharacterDieSlot] = []
const _initial_war_transport_health_maximum: int = 1000
const _initial_money: int = 100

const _character_factories: Array[CharacterFactory] = [
    preload("res://assets/data/characters/001_mouse_char.tres"),
    preload("res://assets/data/characters/002_lizard_char.tres"),
    preload("res://assets/data/characters/003_test_pal.tres"),
    preload("res://assets/data/characters/004_test_pal.tres"),
    preload("res://assets/data/characters/005_test_pal.tres"),
    preload("res://assets/data/characters/006_test_pal.tres"),
    preload("res://assets/data/characters/007_test_pal.tres"),
    preload("res://assets/data/characters/008_test_pal.tres"),
    preload("res://assets/data/characters/009_test_pal.tres"),
    preload("res://assets/data/characters/010_test_pal.tres"),
    preload("res://assets/data/characters/011_test_pal.tres"),
    preload("res://assets/data/characters/012_test_pal.tres"),
]
const _starting_character_idxs: Array[int] = [
    0,
    1,
]

var barriers_overcome_count: int
var current_barrier_cost_to_overcome_number: int
var current_character_die_slots: Array[CharacterDieSlot]
var war_transport_health_current: int
var war_transport_health_maximum: int

var hired_characters: Array[Character]
var unhired_characters: Array[Character]
var applicants: Array[Character]
var should_generate_new_applicants: bool

var current_money: int

func _ready():
    reset_values()

func reset_values() -> void:
    set_barriers_overcome_count(_initial_barriers_overcome_count)
    set_current_character_die_slots(_initial_character_die_slots)
    set_war_transport_health_maximum(_initial_war_transport_health_maximum)
    set_money(_initial_money)

    set_war_transport_health_to_maximum()
    initialize_characters()
    should_generate_new_applicants = true

func initialize_characters() -> void:
    var characters: Array = _character_factories.map(func(x): return x.instantiate())
    hired_characters = []
    unhired_characters = []
    applicants = []
    for i in range(characters.size()):
        if i in _starting_character_idxs:
            hired_characters.append(characters[i])
        else:
            unhired_characters.append(characters[i])
    
    hire_character(get_random_unhired(1)[0])

# TODO: Could move this to indoor_preparation class if we want the logic out of the DB.
func get_random_unhired(count: int) -> Array[Character]:
    if count >= unhired_characters.size():
        return unhired_characters
    else:
        var possible_indices: Array = range(unhired_characters.size())
        var random_selections: Array[int] = []
        for i in range(count):
            var selected_index: int = possible_indices.pick_random()
            if selected_index in random_selections:
                selected_index = possible_indices.pick_random()
            while selected_index in random_selections:
                selected_index = (selected_index + 1) % unhired_characters.size()
            random_selections.append(selected_index)
        
        var selected_characters: Array[Character] = []
        for idx: int in random_selections:
            selected_characters.append(unhired_characters[idx])
        return selected_characters

func set_current_applicants(new_applicants: Array[Character]) -> void:
    applicants = new_applicants

func hire_character(character: Character) -> void:
    unhired_characters.erase(character)
    applicants.erase(character)
    hired_characters.append(character)

func set_barriers_overcome_count(updated_count: int) -> void:
    barriers_overcome_count = updated_count

func set_current_barrier_cost_to_overcome_number(updated_number: int) -> void:
    current_barrier_cost_to_overcome_number = updated_number

func set_current_character_die_slots(
    updated_slots: Array[CharacterDieSlot]
) -> void:
    current_character_die_slots = updated_slots

func set_war_transport_health_current(updated_health: int) -> void:
    war_transport_health_current = updated_health

func set_war_transport_health_maximum(updated_health: int) -> void:
    war_transport_health_maximum = updated_health

func set_war_transport_health_to_maximum() -> void:
    set_war_transport_health_current(_initial_war_transport_health_maximum)

func set_money(updated_money: int) -> void:
    current_money = updated_money
