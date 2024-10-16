class_name ApplicantsDisplay extends ResourceDisplay

var fade_tween: Tween

func _ready() -> void:
    super()
    database.applicant_count_changed.connect(_on_resource_changed)
    current_display_value = database.applicants.size()

func _on_resource_changed(new_value, old_value):
    super(new_value, old_value)

    if new_value == 0 and visible:
        if fade_tween != null and fade_tween.is_valid():
            fade_tween.kill()
        fade_tween = create_tween()
        fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, 2)
        fade_tween.tween_callback(hide)

    elif new_value != 0 and modulate != Color.WHITE:
        if fade_tween != null and fade_tween.is_valid():
            fade_tween.kill()
        fade_tween = create_tween()
        fade_tween.tween_callback(show)
        fade_tween.tween_property(self, "modulate", Color.WHITE, 2)
