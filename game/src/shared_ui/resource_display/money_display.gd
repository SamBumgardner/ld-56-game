class_name MoneyDisplay extends ResourceDisplay

func _ready() -> void:
    super()
    database.money_changed.connect(_on_resource_changed)
    current_display_value = database.current_money
