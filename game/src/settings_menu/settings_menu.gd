extends Control


@onready var audio_manager: AudioManager = $AudioManager
@onready var settings_volume = (
    $CenterContainer/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/SettingsVolume
)


const setting_to_percentage_ratio = 100


func _slider_value_to_volume(slider_value: float) -> float:
    var rounded_percentage = roundf(slider_value)
    return rounded_percentage / setting_to_percentage_ratio


#region Set volume

func _set_music_volume_from_database_default() -> void:
    var updated_volume = _slider_value_to_volume(
        Database.get_settings_default_audio_volume_music()
        * setting_to_percentage_ratio
    )
    SoundManager.set_music_volume(updated_volume)
    Database.set_audio_volume_music(updated_volume)


func _set_sfx_volume_from_database_default() -> void:
    var updated_volume = _slider_value_to_volume(
        Database.get_settings_default_audio_volume_sfx()
        * setting_to_percentage_ratio
    )
    SoundManager.set_ambient_sound_volume(updated_volume)
    Database.set_audio_volume_sfx(updated_volume)

#endregion Set volume


func _on_back_button_pressed():
    get_tree().change_scene_to_file("res://src/start_menu/StartMenu.tscn")


func _on_reset_to_defaults_button_pressed():
    _set_music_volume_from_database_default()
    _set_sfx_volume_from_database_default()

    settings_volume.refresh()

    audio_manager.on_sfx_volume_updated()
