class_name Scenario extends Resource

@export_category("Information")
@export var scenario_name: String
@export_multiline var scenario_description: String
@export var difficulty_rating: int = 0

@export_category("Gameplay")
@export var total_distance: int = 200
@export var segments: Array[ScenarioSegment]
@export var gameplay_init_values: GameplayInitValues

@export_category("Starting Character Info")
@export var available_characters: Array[CharacterFactory] = [
    preload("res://assets/data/characters/001_squirrel_char.tres"),
    preload("res://assets/data/characters/002_frog_char.tres"),
    preload("res://assets/data/characters/003_raccoon_char.tres"),
    preload("res://assets/data/characters/004_bird_char.tres"),
    preload("res://assets/data/characters/005_ape_char.tres"),
    preload("res://assets/data/characters/006_mouse_char.tres"),
    preload("res://assets/data/characters/007_mole_char.tres"),
    preload("res://assets/data/characters/008_lizard_char.tres"),
    preload("res://assets/data/characters/009_snake_char.tres"),
    preload("res://assets/data/characters/010_mantis_char.tres"),
    preload("res://assets/data/characters/011_rabbit_char.tres"),
    preload("res://assets/data/characters/012_fish_char.tres"),
]
@export var possible_start_char_options: Array[int] = [
    0, 1, 2
]
@export var start_char_count: int = 3

func get_current_region(distance_traveled: int) -> Region:
    var current_region: Region = null

    for segment: ScenarioSegment in segments:
        if segment.starts_at <= distance_traveled or current_region == null:
            current_region = segment.region
    
    return current_region
