class_name TotalPowerDisplay extends MarginContainer

@onready var combat_math_formulas: CombatMathFormulas = CombatMathFormulas.new()
@onready var total_value_label: Label = $PanelContainer/VBoxContainer/TotalValue

func _ready() -> void:
    refresh()

func refresh() -> void:
    total_value_label.text = String.num_int64(_calculate_total_power())

func _calculate_total_power() -> int:
    return combat_math_formulas.total_dice_with_matching_stat_type_multiplier(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )
