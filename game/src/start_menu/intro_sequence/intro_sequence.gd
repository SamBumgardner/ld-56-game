class_name IntroSequence extends Control

signal intro_finished()

static var has_played_once: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
    animation_player.play("intro_sequence")
    if not has_played_once:
        has_played_once = true
    else:
        await get_tree().process_frame == true
        animation_player.advance(animation_player.current_animation.length())

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    intro_finished.emit()

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_accept") and animation_player.is_playing():
        const flash_point: float = 5.5
        if animation_player.current_animation_position < flash_point:
            animation_player.seek(flash_point)
