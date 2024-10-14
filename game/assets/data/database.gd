# Defines variables shared across scenes with the correct data types.
extends Node

signal health_changed(new_value: int, old_value: int)
signal money_changed(new_value: int, old_value: int)
signal fuel_changed(new_value: int, old_value: int)
signal die_slots_set(was_reroll: bool)
signal die_slot_changed(changed_die_slot: CharacterDieSlot)
signal barrier_changed(new_barrier_data: BarrierData)
signal checkpoint_saved()

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

const CHECKPOINT_SAVED_MESSAGE: String = "Checkpoint Reached!"
const CHECKPOINT_SAVED_DURATION: float = 2

const _settings_default_audio_volume_music: float = 0.5
const _settings_default_audio_volume_sfx: float = 0.5
const _initial_audio_volume_music: float = 0.5
const _initial_audio_volume_sfx: float = 0.5
const _initial_barriers_linear_scale_amount: int = 1
const _initial_barriers_stat_type_to_overcome: StatType = StatType.MIGHT
const _initial_barriers_overcome_count: int = 0
const _initial_barriers_cost_to_overcome_number: int = 0
const _initial_reroll_fuel_cost = 1
const _initial_character_die_slots: Array[CharacterDieSlot] = []
const _initial_money: int = 50
const _initial_fuel: int = 2
const _initial_matching_stat_type_multiplier: int = 2
const _initial_war_transport_health_maximum: int = 10

const _maximum_fuel: int = 10

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

var audio_volume_initialized: bool
var audio_volume_music: float
var audio_volume_sfx: float
var barriers_overcome_count: int
var barriers_linear_scale_amount: int
var current_barrier_stat_type_to_overcome: StatType
var current_barrier_cost_to_overcome_number: int
var current_barrier_data: BarrierData

var current_reroll_fuel_cost: int
var current_character_die_slots: Array[CharacterDieSlot]
var current_matching_stat_type_multiplier: int
var war_transport_health_current: int
var war_transport_health_maximum: int

var hired_characters: Array[Character]
var unhired_characters: Array[Character]
var applicants: Array[Character]
var should_generate_new_applicants: bool

var current_money: int
var current_fuel: int

var saved_state: GameplayInitValues

var hired_character_count: int:
    get():
        return hired_characters.size()
    set(value):
        push_error("attempted to set derived field. Don't do this")

var purchased_upgrade_count: int:
    get():
        var total: int = 0
        for character: Character in hired_characters:
            total += character.upgrade_level
        return total
    set(value):
        push_error("attempted to set derived field. Don't do this")

func _ready():
    _ready_audio_volumes()
    reset_values()

# Like reset_values
func load_from_init_values(init_values: GameplayInitValues):
    set_barriers_overcome_count(init_values.barriers_overcome_count)
    set_barriers_linear_scale_amount(init_values.barriers_linear_scale_amount)
    set_current_barrier_cost_to_overcome_number(
        init_values.current_barrier_cost_to_overcome_number
    )
    set_current_barrier_stat_type_to_overcome(
        init_values.current_barrier_stat_type_to_overcome
    )
    if init_values.current_barrier_data != null:
        set_current_barrier_data(init_values.current_barrier_data)
    set_current_character_die_slots(init_values.current_character_die_slots.duplicate())
    set_current_matching_stat_type_multiplier(
        init_values.current_matching_stat_type_multiplier
    )
    set_war_transport_health_maximum(init_values.war_transport_health_maximum)
    set_war_transport_health_current(init_values.war_transport_health_current)
    set_money(init_values.current_money)
    set_fuel(init_values.current_fuel)
    set_reroll_fuel_cost(init_values.current_reroll_fuel_cost)

    hired_characters = init_values.hired_characters
    unhired_characters = init_values.unhired_characters
    applicants = init_values.applicants
    should_generate_new_applicants = init_values.should_generate_new_applicants

# Excludes chosen settings for audio volume.
func reset_values() -> void:
    set_barriers_overcome_count(_initial_barriers_overcome_count)
    set_barriers_linear_scale_amount(_initial_barriers_linear_scale_amount)
    set_current_barrier_cost_to_overcome_number(
        _initial_barriers_cost_to_overcome_number
    )
    set_current_barrier_stat_type_to_overcome(
        _initial_barriers_stat_type_to_overcome
    )
    set_current_character_die_slots(_initial_character_die_slots.duplicate())
    set_current_matching_stat_type_multiplier(
        _initial_matching_stat_type_multiplier
    )
    set_war_transport_health_maximum(_initial_war_transport_health_maximum)
    set_money(_initial_money)
    set_fuel(_initial_fuel)
    set_reroll_fuel_cost(_initial_reroll_fuel_cost)

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
    initialize_missing_die_slots()

func initialize_missing_die_slots() -> void:
    var current_die_slots: Array[CharacterDieSlot] = current_character_die_slots
    for character: Character in hired_characters:
        var has_die_slot: bool = false
        for die_slot: CharacterDieSlot in current_die_slots:
            if die_slot.character == character:
                has_die_slot = true
                break

        if not has_die_slot:
            var new_die_slot = CharacterDieSlot.new(character, false)
            new_die_slot.last_roll_result = new_die_slot.roll_action()
            current_die_slots.append(new_die_slot)

    set_current_character_die_slots(current_die_slots)

func save_checkpoint():
    saved_state = GameplayInitValues.new(true)
    checkpoint_saved.emit()

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

func get_settings_default_audio_volume_music() -> float:
    return _settings_default_audio_volume_music

func get_settings_default_audio_volume_sfx() -> float:
    return _settings_default_audio_volume_sfx

func set_audio_volume_initialized(is_initialized: bool) -> void:
    audio_volume_initialized = is_initialized

func set_audio_volume_music(volume: float) -> void:
    audio_volume_music = volume

func set_audio_volume_sfx(volume: float) -> void:
    audio_volume_sfx = volume

func set_barriers_linear_scale_amount(updated_number: int) -> void:
    barriers_linear_scale_amount = updated_number

func set_barriers_overcome_count(updated_count: int) -> void:
    barriers_overcome_count = updated_count

func set_current_barrier_stat_type_to_overcome(updated_stat_type: StatType) -> void:
    current_barrier_stat_type_to_overcome = updated_stat_type

func set_current_barrier_cost_to_overcome_number(updated_number: int) -> void:
    current_barrier_cost_to_overcome_number = updated_number

func set_current_barrier_data(updated_barrier_data: BarrierData) -> void:
    current_barrier_data = updated_barrier_data
    barrier_changed.emit(current_barrier_data)

func set_current_character_die_slots(
    updated_slots: Array[CharacterDieSlot],
    was_reroll: bool = false
) -> void:
    current_character_die_slots = updated_slots
    die_slots_set.emit(was_reroll)

func set_current_matching_stat_type_multiplier(updated_number: int) -> void:
    current_matching_stat_type_multiplier = updated_number

func set_war_transport_health_current(updated_health: int) -> void:
    var old_health = war_transport_health_current
    war_transport_health_current = updated_health
    health_changed.emit(updated_health, old_health)

func set_war_transport_health_maximum(updated_health: int) -> void:
    war_transport_health_maximum = updated_health

func set_war_transport_health_to_maximum() -> void:
    set_war_transport_health_current(_initial_war_transport_health_maximum)

func set_money(updated_money: int) -> void:
    var old_money = current_money
    current_money = updated_money
    money_changed.emit(updated_money, old_money)

func set_fuel(updated_fuel: int) -> void:
    var old_fuel = current_fuel
    current_fuel = min(updated_fuel, _maximum_fuel)
    fuel_changed.emit(current_fuel, old_fuel)

func set_reroll_fuel_cost(updated_cost: int) -> void:
    current_reroll_fuel_cost = updated_cost

func get_character_die_slot(character_idx: int) -> CharacterDieSlot:
    var result: CharacterDieSlot = null
    if character_idx < current_character_die_slots.size():
        result = current_character_die_slots[character_idx]
    return result

func get_die_slot_by_character(character: Character) -> CharacterDieSlot:
    var result: CharacterDieSlot = null
    for die_slot: CharacterDieSlot in current_character_die_slots:
        if die_slot.character == character:
            result = die_slot
            break
    return result

func set_die_slot_frozen_status(character: Character, new_freeze: bool) -> void:
    var die_slot = get_die_slot_by_character(character)
    die_slot.is_frozen = new_freeze
    die_slot_changed.emit(die_slot)

func _ready_audio_volumes() -> void:
    set_audio_volume_initialized(false)
    set_audio_volume_music(_initial_audio_volume_music)
    set_audio_volume_sfx(_initial_audio_volume_sfx)
