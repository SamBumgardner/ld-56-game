extends Control


signal sfx_volume_updated


@onready var audio_manager: AudioManager = $AudioManager
@onready var music_slider: Slider = (
    $CenterContainer/VBoxContainer/VolumeSettings/MusicVolumePercentageSlider
)
@onready var sfx_slider: Slider = (
    $CenterContainer/VBoxContainer/VolumeSettings/SfxVolumePercentageSlider
)
@onready var music_volume_percentage_display: Label = (
    $CenterContainer/VBoxContainer/VolumeSettings/MusicDescription/MusicVolumePercentage
)
@onready var sfx_volume_percentage_display: Label = (
    $CenterContainer/VBoxContainer/VolumeSettings/SfxDescription/SfxVolumePercentage
)


const setting_to_percentage_ratio = 100


func _ready():
    _initialize_volumes()


func _initialize_volumes():
    print_debug(
        'Initial slider values of SFX and music are: (',
        sfx_slider.value,
        ',',
        music_slider.value,
        ')'
    )
    sfx_slider.value = int(
        Database.audio_volume_sfx * setting_to_percentage_ratio
    )
    music_slider.value = int(
        Database.audio_volume_music * setting_to_percentage_ratio
    )
    print_debug(
        'Slider values of SFX and music are: (',
        sfx_slider.value,
        ',',
        music_slider.value,
        ')'
    )


func _on_music_volume_percentage_slider_drag_ended(value_changed):
    if !value_changed:
        return

    _set_music_volume_from_slider()


func _on_sfx_volume_percentage_slider_drag_ended(value_changed):
    if !value_changed:
        audio_manager.on_sfx_volume_updated()
        return

    _set_sfx_volume_from_slider()

    audio_manager.on_sfx_volume_updated()


func _on_music_volume_percentage_slider_value_changed(value):
    music_volume_percentage_display.text = str(value) + '%'


func _on_sfx_volume_percentage_slider_value_changed(value):
    sfx_volume_percentage_display.text = str(value) + '%'


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


func _set_music_volume_from_slider() -> void:
    var updated_volume = _slider_value_to_volume(music_slider.value)
    SoundManager.set_music_volume(updated_volume)
    Database.set_audio_volume_music(updated_volume)


func _set_sfx_volume_from_database_default() -> void:
    var updated_volume = _slider_value_to_volume(
        Database.get_settings_default_audio_volume_sfx()
        * setting_to_percentage_ratio
    )
    SoundManager.set_sound_volume(updated_volume)
    Database.set_audio_volume_sfx(updated_volume)


func _set_sfx_volume_from_slider() -> void:
    var updated_volume = _slider_value_to_volume(sfx_slider.value)
    SoundManager.set_sound_volume(updated_volume)
    Database.set_audio_volume_sfx(updated_volume)

#endregion Set volume


func _on_reset_to_defaults_button_pressed():
    _set_music_volume_from_database_default()
    _set_sfx_volume_from_database_default()

    _initialize_volumes()

    audio_manager.on_sfx_volume_updated()
