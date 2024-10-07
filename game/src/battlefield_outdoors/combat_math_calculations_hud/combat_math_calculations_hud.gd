extends MarginContainer


@onready var combat_math_formulas = CombatMathFormulas.new()
@onready var dice_total_value = (
    $Rows/DiceTotal/Value
)
@onready var stat_type_match_icon = (
    $Rows/CalculationStatTypeMatch/Symbol
)
@onready var subtotal_stat_type_match_value = (
    $Rows/CalculationStatTypeMatch/Value
)


func _ready():
    refresh()


func refresh() -> void:
    dice_total_value.text = str(_get_war_transport_damage_reduction_amount())
    stat_type_match_icon.texture = Database.stat_type_to_icon[
        Database.current_barrier_stat_type_to_overcome
    ]
    print_debug('_get_subtotal_stat_type_match(): ', _get_subtotal_stat_type_match())
    subtotal_stat_type_match_value.text = str(_get_subtotal_stat_type_match())


func _get_subtotal_stat_type_match() -> int:
    return combat_math_formulas.total_dice_only_matching_stat_type_multiplier(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )


# Sum dice results, multiplying dice that match the target StatType.
func _get_war_transport_damage_reduction_amount() -> int:
    return combat_math_formulas.total_dice_with_matching_stat_type_multiplier(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )
