class_name CombatResultsSummary extends VBoxContainer

const DISPLAY_DURATION: float = 2
const FLOAT_OFFSET: Vector2 = Vector2(0, -100)

@onready var health_change_display: ResourceChangeLine = $HealthChange
@onready var money_change_display: ResourceChangeLine = $MoneyChange
@onready var fuel_change_display: ResourceChangeLine = $FuelChange

@onready var start_position: Vector2 = position

func set_combat_results(health_change: int, money_change: int, fuel_change: int):
    health_change_display.set_change_amount(health_change)
    money_change_display.set_change_amount(money_change)
    fuel_change_display.set_change_amount(fuel_change)

func display_combat_results():
    show()
    modulate = Color.WHITE
    position = start_position

    var display_tween: Tween = create_tween()
    display_tween.tween_property(self, "modulate", Color.TRANSPARENT, DISPLAY_DURATION)
    display_tween.parallel().tween_property(self, "position", start_position + FLOAT_OFFSET, DISPLAY_DURATION)
    display_tween.tween_callback(hide)
