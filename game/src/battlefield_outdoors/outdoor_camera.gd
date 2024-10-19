class_name OutdoorCamera extends Camera2D

var scroll_tween: Tween

func scroll_distance(distance: Vector2, duration: float):
    if scroll_tween != null and scroll_tween.is_valid():
        scroll_tween.kill()
    
    scroll_tween = create_tween()
    scroll_tween.set_ease(Tween.EASE_IN_OUT)
    scroll_tween.set_trans(Tween.TRANS_QUAD)
    scroll_tween.tween_property(self, "position", position + distance, duration)
