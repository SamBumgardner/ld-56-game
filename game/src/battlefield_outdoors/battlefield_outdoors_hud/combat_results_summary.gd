class_name CombatResultsSummary extends VBoxContainer

const DISPLAY_DURATION: float = 2
const FLOAT_OFFSET: Vector2 = Vector2(0, -100)

@onready var distance_change_display: ResourceChangeLine = $DistanceChange
@onready var health_change_display: ResourceChangeLine = $HealthChange
@onready var money_change_display: ResourceChangeLine = $MoneyChange
@onready var fuel_change_display: ResourceChangeLine = $FuelChange

@onready var start_position: Vector2 = position

func set_combat_results(distance_change: int, health_change: int, money_change: int, fuel_change: int):
    distance_change_display.set_change_amount(distance_change)
    health_change_display.set_change_amount(health_change)
    money_change_display.set_change_amount(money_change)
    fuel_change_display.set_change_amount(fuel_change)
    

func set_combat_results_bundled(combat_result: CombatResult):
    distance_change_display.set_change_amount(combat_result.distance_change)
    health_change_display.set_change_amount(combat_result.health_change)
    money_change_display.set_change_amount(combat_result.money_change)
    fuel_change_display.set_change_amount(combat_result.fuel_change)

func display_combat_results():
    modulate = Color.WHITE
    position = start_position

    var display_tween: Tween = create_tween()
    display_tween.tween_callback(show)
    display_tween.tween_property(self, "modulate", Color.TRANSPARENT, DISPLAY_DURATION)
    display_tween.parallel().tween_property(self, "position", start_position + FLOAT_OFFSET, DISPLAY_DURATION)
    display_tween.tween_callback(hide)

class CombatResult extends RefCounted:
    var distance_change: int = 0
    var health_change: int = 0
    var money_change: int = 0
    var fuel_change: int = 0

    func _init(_distance_change = 0, _health_change = 0, _money_change = 0, _fuel_change = 0) -> void:
        distance_change = _distance_change
        health_change = _health_change
        money_change = _money_change
        fuel_change = _fuel_change
    
    func clear() -> void:
        distance_change = 0
        health_change = 0
        money_change = 0
        fuel_change = 0
