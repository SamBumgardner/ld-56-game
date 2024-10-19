class_name VictoryScene extends GameOver

@export var initial_cover_fade_duration: float = 1

@onready var cover: ColorRect = $ColorRect

func _ready() -> void:
    cover.show()
    var cover_tween: Tween = create_tween()
    cover_tween.tween_property(cover, "self_modulate", Color.TRANSPARENT, initial_cover_fade_duration)
    cover_tween.tween_callback(cover.hide)
    super()
