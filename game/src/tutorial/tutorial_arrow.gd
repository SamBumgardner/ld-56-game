class_name TutorialArrow extends Control

@onready var arrow: TextureRect = $Arrow

var bounce_tween: Tween
var offset_distance: Vector2 = Vector2(-32, -64)
var bounce_duration: float = .5
var bounce_distance: Vector2 = Vector2(0, 24)

var target_tween: Tween
var focus_transition_duration: float = 2

func _ready():
    bounce_tween = create_tween()
    bounce_tween.set_trans(Tween.TRANS_CUBIC)
    bounce_tween.set_ease(Tween.EASE_IN)
    bounce_tween.tween_method(_arrow_bounce, 0.0, 1.0, bounce_duration)
    bounce_tween.set_ease(Tween.EASE_OUT)
    bounce_tween.tween_method(_arrow_bounce, 1.0, 0.0, bounce_duration)
    bounce_tween.set_loops()

func change_target(target_global_position: Vector2, arrow_rotation: float = 0.0):
    if target_tween != null and target_tween.is_valid():
        target_tween.kill()
    
    target_tween = create_tween()
    target_tween.set_ease(Tween.EASE_IN_OUT)
    target_tween.set_trans(Tween.TRANS_QUAD)
    target_tween.tween_property(self, "global_position", target_global_position, focus_transition_duration)
    target_tween.parallel()
    target_tween.tween_property(arrow, "rotation", arrow_rotation, focus_transition_duration)

func _arrow_bounce(value: float):
    var root = global_position + (offset_distance - bounce_distance).rotated(arrow.rotation)
    arrow.global_position = root + (Vector2(0, value) * bounce_distance).rotated(arrow.rotation)
