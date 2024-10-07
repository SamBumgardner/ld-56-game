extends MarginContainer


@onready var combat_math_formulas = CombatMathFormulas.new()
@onready var dice_total_value = (
    $Rows/DiceTotal/Value
)
@onready var stat_type_match_icon = (
    $Rows/CalculationStatTypeMatch/Symbol
)
@onready var subtotal_remaining_icons_grid = (
    $Rows/CalculationRemaining/UnusedStatTypes
)
@onready var subtotal_remaining_value = (
    $Rows/CalculationRemaining/Value
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
    subtotal_stat_type_match_value.text = str(_get_subtotal_stat_type_match())
    _set_non_match_icons_to_grid()
    subtotal_remaining_value.text = str(_get_subtotal_remaining_value())


func _get_subtotal_remaining_value() -> int:
    return combat_math_formulas.total_dice_leftover(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )


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


func _set_non_match_icons_to_grid() -> void:
    var grid_icons = subtotal_remaining_icons_grid.get_children()
    for icon in grid_icons:
        icon.visible = false

    var remaining_icon_list = [
        Database.StatType.MIGHT,
        Database.StatType.WIT,
        Database.StatType.CHAOS
    ].filter(
        func(stat_type: Database.StatType): return (
            stat_type != Database.current_barrier_stat_type_to_overcome
        )
    )

    for remaining_icon_index in remaining_icon_list.size():
        grid_icons[remaining_icon_index].texture = (
            Database.stat_type_to_icon[
                remaining_icon_list[remaining_icon_index]
            ]
        )
        grid_icons[remaining_icon_index].visible = true
