# Play audio triggered by signals.
class_name AudioManager extends Node

@export var background_music_default: AudioStream

@export var sfx_button_click: AudioStream
@export var sfx_button_hover: AudioStream


const _bus_name_music = 'Music'
const _bus_name_sfx_ui = 'SFX UI'


func _ready():
    if !Database.audio_volume_initialized:
        Database.set_audio_volume_initialized(true)

    SoundManager.set_default_music_bus(_bus_name_music)
    SoundManager.set_default_ambient_sound_bus(_bus_name_sfx_ui)

    SoundManager.set_ambient_sound_volume(Database.audio_volume_sfx)
    SoundManager.set_music_volume(Database.audio_volume_music)


# Listen for a custom signal in order to delay until volume is updated.
func on_sfx_volume_updated():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)


# After leaving the start menu, start playing the background music.
func _start_background_music():
    if SoundManager.is_music_playing():
        return

    SoundManager.play_music(background_music_default)


#region Button mouse entered

func _on_quit_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_reset_to_defaults_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_settings_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_start_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

#endregion Button mouse entered


#region Button press

func _on_quit_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_settings_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_start_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

#endregion Button press


#region Scene arrival

func _on_gameplay_ready():
    _start_background_music()

func _on_settings_menu_ready():
    _start_background_music()

#endregion Scene arrival


#region Slider drag ended

func _on_music_volume_percentage_slider_drag_ended(_value_changed):
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

#endregion Slider drag ended
