class_name BattlefieldOutdoorsWarTransport extends Node2D


@onready var combat_math_calculations_hud: MarginContainer = (
    $Columns/CombatMathCalculationsHud
)
@onready var combat_math_formulas: CombatMathFormulas = CombatMathFormulas.new()
@onready var grid_of_dice_results: GridOfDiceResults = (
    $Columns/Units/GridOfDiceResults
)


# TODO: Call when the barrier changes.
func refresh() -> void:
    # Handle edge case of load order, ignore unloaded child.
    if combat_math_calculations_hud != null:
        combat_math_calculations_hud.refresh()


# Sum dice results, multiplying dice that match the target StatType.
func _get_war_transport_damage_reduction_amount() -> int:
    return combat_math_formulas.total_dice_with_matching_stat_type_multiplier(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )


func _on_battlefield_outdoors_barrier_barrier_stat_type_updated() -> void:
    refresh()


func _on_battlefield_outdoors_hud_dice_roll_requested() -> void:
    _roll_dice()


func _roll_dice() -> void:
    grid_of_dice_results.roll_dice()
    refresh()
