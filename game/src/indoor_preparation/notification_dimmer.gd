extends ColorRect

const FADE_IN_DURATION: float = .5

var fade_in_tween: Tween

func _ready() -> void:
    visibility_changed.connect(_on_show)

func _on_show():
    if visible:
        self_modulate = Color.TRANSPARENT
        if fade_in_tween != null and fade_in_tween.is_running():
            fade_in_tween.stop()
        fade_in_tween = create_tween()
        fade_in_tween.set_ease(Tween.EASE_OUT)
        fade_in_tween.set_trans(Tween.TRANS_CUBIC)
        fade_in_tween.tween_property(self, "self_modulate", Color.WHITE, FADE_IN_DURATION)
