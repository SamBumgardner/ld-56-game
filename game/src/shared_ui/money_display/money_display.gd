class_name MoneyDisplay extends PanelContainer

const COINS_PER_SECOND: float = 30.0
const MAX_DURATION: float = 3
const MIN_DURATION: float = .1

const COLOR_CHANGE_DURATION: float = 2
const COLOR_INCREASE: Color = Color.GREEN
const COLOR_DECREASE: Color = Color.DARK_ORANGE
const COLOR_INSUFFICIENT: Color = Color.RED

@onready var database: Database = $"/root/Database"
@onready var amount_label: Label = $MarginContainer/HBoxContainer/Amount

var start_position: Vector2
var current_display_value: int:
    set(new_value):
        current_display_value = new_value
        amount_label.text = String.num_int64(new_value)
var value_tween: Tween
var color_tween: Tween
var position_tween: Tween

func _ready() -> void:
    start_position = position
    database.money_changed.connect(_on_money_changed)
    current_display_value = database.current_money

func force_display_resolution():
    if value_tween != null and value_tween.is_running():
        value_tween.custom_step(MAX_DURATION)
    if color_tween != null and color_tween.is_running():
        color_tween.custom_step(COLOR_CHANGE_DURATION)
    if position_tween != null and position_tween.is_valid():
        position_tween.custom_step(MAX_DURATION)

func _on_insufficient_funds() -> void:
    _set_up_color_tween(COLOR_INSUFFICIENT)
    _create_position_tween()

func _create_position_tween():
    if position_tween != null and position_tween.is_valid():
        position_tween.stop()
    position_tween = create_tween()
    position_tween.tween_method(shake_display, 0, 0, .1)
    position_tween.tween_property(self, "position", start_position, 0)

func shake_display(_value: float):
    position = start_position + (Vector2.ONE.rotated(randf_range(0, 6.29)) * 5)

func _on_money_changed(new_money_value, old_money_value) -> void:
    _set_up_value_tween(new_money_value)
    var color = COLOR_INCREASE if new_money_value > old_money_value else COLOR_DECREASE
    _set_up_color_tween(color)

func _set_up_color_tween(color: Color) -> void:
    if color_tween != null and color_tween.is_running():
        color_tween.stop()
    
    amount_label.modulate = color
    color_tween = create_tween()
    color_tween.set_ease(Tween.EASE_OUT)
    color_tween.set_trans(Tween.TRANS_CUBIC)
    color_tween.tween_property(amount_label, "modulate", Color.WHITE, COLOR_CHANGE_DURATION)

func _set_up_value_tween(new_money_value) -> void:
    if value_tween != null and value_tween.is_running():
        value_tween.stop()

    var duration = _calculate_money_tween_duration(current_display_value, new_money_value)
    
    value_tween = create_tween()
    value_tween.set_ease(Tween.EaseType.EASE_OUT)
    value_tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
    value_tween.tween_property(self, "current_display_value", new_money_value, duration)
    
func _calculate_money_tween_duration(old_value: int, new_value: int) -> float:
    return clamp(abs(old_value - new_value) / COINS_PER_SECOND, MIN_DURATION, MAX_DURATION)
