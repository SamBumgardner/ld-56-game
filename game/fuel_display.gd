class_name FuelDisplay extends ResourceDisplay

func _ready() -> void:
    super()
    database.fuel_changed.connect(_on_resource_changed)
    current_display_value = database.current_fuel
