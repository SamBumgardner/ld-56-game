class_name BattlefieldOutdoorsWarTransport extends Sprite2D

@onready var start_position = position

var movement_tween: Tween

func charge_at_target(target_position: Vector2, duration: float) -> void:
    movement_tween = clear_tween(movement_tween)
    movement_tween.tween_property(self, "position", target_position, duration)

func return_to_start_position(duration: float) -> void:
    movement_tween = clear_tween(movement_tween)
    movement_tween.tween_property(self, "position", start_position, duration)

func clear_tween(tween: Tween) -> Tween:
    if tween != null and tween.is_running():
        tween.kill()
    
    return create_tween()