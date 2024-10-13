class_name BattlefieldOutdoorsWarTransport extends Sprite2D

@onready var start_position = position

var movement_tween: Tween

func charge_at_target(target_global_position: Vector2, duration: float) -> void:
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
