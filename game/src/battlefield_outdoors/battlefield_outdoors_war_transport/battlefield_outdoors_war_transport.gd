class_name BattlefieldOutdoorsWarTransport extends Sprite2D

@onready var power: Label = $Columns/Power
@onready var start_position = position

var movement_tween: Tween
var power_display_tween: Tween

func charge_to_target(target_global_position: Vector2, duration: float) -> void:
    print_debug("global postion %s" % global_position)
    movement_tween = clear_tween(movement_tween)
    movement_tween.tween_property(self, "global_position", target_global_position, duration)

func return_to_start_position(duration: float) -> void:
    movement_tween = clear_tween(movement_tween)
    movement_tween.tween_property(self, "position", start_position, duration)

func clear_tween(tween: Tween) -> Tween:
    if tween != null and tween.is_running():
        tween.kill()
    
    return create_tween()

func display_power(power_value: int, duration: float):
    power.text = String.num_int64(power_value)
    power.modulate = Color.TRANSPARENT

    if power_display_tween != null and power_display_tween.is_valid():
        power_display_tween.stop()
    power_display_tween = create_tween()
    power_display_tween.tween_callback(power.show)
    power_display_tween.tween_property(
        power,
        "modulate",
        Color.WHITE,
        duration
    )

func hide_power(duration: float):
    power.modulate = Color.WHITE

    if power_display_tween != null and power_display_tween.is_valid():
        power_display_tween.stop()
    power_display_tween = create_tween()
    power_display_tween.tween_property(
        power,
        "modulate",
        Color.TRANSPARENT,
        duration
    )
    power_display_tween.tween_callback(power.hide)
