class_name MoneyDisplay extends PanelContainer

const COINS_PER_SECOND: float = 30.0
const MAX_DURATION: float = 3
const MIN_DURATION: float = .1

@onready var database: Database = $"/root/Database"
@onready var amount_label: Label = $MarginContainer/HBoxContainer/Amount

var current_display_value: int:
    set(new_value):
        current_display_value = new_value
        amount_label.text = String.num_int64(new_value)
var value_tween: Tween

func _ready() -> void:
    database.money_changed.connect(_on_money_changed)
    current_display_value = database.current_money

func force_display_resolution():
    value_tween.custom_step(MAX_DURATION)

func _on_money_changed(new_money_value) -> void:
    if value_tween != null and value_tween.is_running():
        value_tween.stop()

    var duration = _calculate_money_tween_duration(current_display_value, new_money_value)
    
    value_tween = create_tween()
    value_tween.set_ease(Tween.EaseType.EASE_OUT)
    value_tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
    value_tween.tween_property(self, "current_display_value", new_money_value, duration)
    
func _calculate_money_tween_duration(old_value: int, new_value: int) -> float:
    return clamp(abs(old_value - new_value) / COINS_PER_SECOND, MIN_DURATION, MAX_DURATION)
