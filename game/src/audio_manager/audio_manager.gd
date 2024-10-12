# Play audio triggered by signals.
class_name AudioManager extends Node


@export var sfx_button_click : AudioStream
@export var sfx_button_hover : AudioStream


func _ready():
    if !Database.audio_volume_initialized:
        Database.set_audio_volume_initialized(true)

    SoundManager.set_ambient_sound_volume(Database.audio_volume_sfx)
    SoundManager.set_music_volume(Database.audio_volume_music)
    SoundManager.set_sound_volume(Database.audio_volume_sfx)


# Listen for a custom signal in order to delay until volume is updated.
func on_sfx_volume_updated():
    SoundManager.play_ui_sound(sfx_button_click)


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
