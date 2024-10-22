class_name IntroSequence extends Control

signal intro_finished()

static var has_played_once: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const animation_time_flash_point: float = 5.5
const animation_time_near_after_flash_point: float = 6
const animation_time_near_end_point: float = 7.49


func _ready():
    animation_player.play("intro_sequence")
    if not has_played_once:
        has_played_once = true
    else:
        await get_tree().process_frame == true
        animation_player.advance(animation_player.current_animation.length())


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    intro_finished.emit()


# Allow skipping the introduction animation in 2 parts when anything is pressed
#  or clicked.
func _process(delta: float) -> void:
    if not animation_player.is_playing() or not Input.is_anything_pressed():
        return

    if animation_player.current_animation_position < animation_time_flash_point:
        animation_player.seek(animation_time_flash_point)
        return

    if (animation_player.current_animation_position
            > animation_time_near_after_flash_point
        and animation_player.current_animation_position
            < animation_time_near_end_point
    ):
        animation_player.seek(animation_time_near_end_point)
