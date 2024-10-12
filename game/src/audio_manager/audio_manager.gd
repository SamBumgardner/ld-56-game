# Play audio triggered by signals.
extends Node


@export var sfx_button_click : AudioStream
@export var sfx_button_hover : AudioStream


const _default_volumes: float = 0.5


func _ready():
    if Database.audio_volume_initialized:
        return

    Database.set_audio_volume_initialized(true)

    SoundManager.set_ambient_sound_volume(_default_volumes)
    SoundManager.set_music_volume(_default_volumes)
    SoundManager.set_sound_volume(_default_volumes)


#region Button mouse entered

func _on_quit_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover)

func _on_settings_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover)

func _on_start_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover)

#endregion Button mouse entered

#region Button press

func _on_quit_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click)

func _on_settings_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click)

func _on_start_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click)

#endregion Button press
