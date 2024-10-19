class_name DistanceRemainingDisplay extends ResourceDisplay

func _ready() -> void:
    super()
    database.distance_remaining_changed.connect(_on_resource_changed)
    current_display_value = database.current_distance_remaining
