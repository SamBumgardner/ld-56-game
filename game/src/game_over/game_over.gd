class_name GameOver extends ColorRect

@onready var title_container: Control = $TitleContainer
@onready var stats_container: Control = $StatsContainer
@onready var button_container: Control = $ButtonContainer


func _ready() -> void:
    const delay_duration: float = .5
    const fade_duration: float = .5
    var fade_in_sequence: Tween = create_tween()

    var children = get_children()
    for child in children:
        child.hide()
        child.modulate = Color.TRANSPARENT
        fade_in_sequence.tween_interval(delay_duration)
        fade_in_sequence.tween_callback(child.show)
        fade_in_sequence.tween_property(child, "modulate", Color.WHITE, fade_duration)
