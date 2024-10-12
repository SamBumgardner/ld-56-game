class_name BattlefieldOutdoorsWarTransport extends Node2D

signal insufficient_fuel()

@onready var grid_of_dice_results: GridOfDiceResults = (
    $Columns/Units/GridOfDiceResults
)

func _on_battlefield_outdoors_hud_dice_roll_requested() -> void:
    if Database.current_fuel < Database.current_reroll_fuel_cost:
        insufficient_fuel.emit()
    else:
        Database.set_fuel(Database.current_fuel - Database.current_reroll_fuel_cost)
        _roll_dice()


func _roll_dice() -> void:
    grid_of_dice_results.roll_dice()
