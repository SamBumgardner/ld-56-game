class_name Scenario extends Resource

@export_category("Information")
@export var scenario_name: String
@export_multiline var scenario_description: String
@export var difficulty_rating: int = 0

@export_category("Gameplay")
@export var total_distance: int = 200
@export var segments: Array[ScenarioSegment]

func get_current_region(distance_traveled: int) -> Region:
    var current_region: Region = null

    for segment: ScenarioSegment in segments:
        if segment.starts_at <= distance_traveled or current_region == null:
            current_region = segment.region
        else:
            break
    
    return current_region
