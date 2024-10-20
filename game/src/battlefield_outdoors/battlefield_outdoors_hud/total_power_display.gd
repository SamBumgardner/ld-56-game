class_name TotalPowerDisplay extends MarginContainer

@onready var combat_math_formulas: CombatMathFormulas = CombatMathFormulas.new()
@export var total_value_label: Label

func _ready() -> void:
    Database.barrier_changed.connect(_on_barrier_changed)
    refresh()

func refresh() -> void:
    total_value_label.text = String.num_int64(_calculate_total_power())

func _calculate_total_power() -> int:
    return combat_math_formulas.total_dice_with_matching_stat_type_multiplier(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )

func hide_total_value():
    total_value_label.hide()

func show_total_value():
    total_value_label.show()

func _on_barrier_changed(_new_barrier: BarrierData):
    refresh()
