class_name ModeTransitionCover extends ColorRect

const TRANSITION_DURATION: float = .25

var fade_tween: Tween

func fade_in():
    _clean_up_running_tween()
    fade_tween = create_tween()
    _apply_fade_in_tween_steps(fade_tween)

func fade_out():
    _clean_up_running_tween()
    fade_tween = create_tween()
    _apply_fade_out_tween_steps(fade_tween)

func fade_in_out(optional_middle_callback: Callable, duration_override: float = TRANSITION_DURATION):
    _clean_up_running_tween()
    fade_tween = create_tween()
    _apply_fade_in_tween_steps(fade_tween, duration_override)
    if optional_middle_callback != null:
        fade_tween.tween_callback(optional_middle_callback)
    _apply_fade_out_tween_steps(fade_tween, duration_override)

func _apply_fade_in_tween_steps(tween: Tween, duration_override: float = TRANSITION_DURATION) -> Tween:
    tween.set_ease(Tween.EaseType.EASE_OUT)
    tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
    tween.tween_property(self, "modulate", Color.TRANSPARENT, .1)
    tween.tween_callback(show)
    tween.tween_interval(TRANSITION_DURATION)
    tween.tween_property(self, "modulate", Color.WHITE, duration_override)
    return tween

func _apply_fade_out_tween_steps(tween: Tween, duration_override: float = TRANSITION_DURATION) -> Tween:
    tween.set_ease(Tween.EaseType.EASE_IN)
    tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
    tween.tween_property(self, "modulate", Color.WHITE, .1)
    tween.tween_interval(TRANSITION_DURATION)
    tween.tween_property(self, "modulate", Color.TRANSPARENT, duration_override)
    tween.tween_callback(hide)
    return tween

func _clean_up_running_tween():
    if fade_tween != null and fade_tween.is_running():
        fade_tween.stop()
