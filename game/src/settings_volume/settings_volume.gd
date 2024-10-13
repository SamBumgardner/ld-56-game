extends VBoxContainer


@onready var audio_manager: AudioManager = $AudioManager
@onready var music_slider: Slider = $MusicVolumePercentageSlider
@onready var sfx_slider: Slider = $SfxVolumePercentageSlider
@onready var music_volume_percentage_display: Label = (
    $MusicDescription/MusicVolumePercentage
)
@onready var sfx_volume_percentage_display: Label = (
    $SfxDescription/SfxVolumePercentage
)


const setting_to_percentage_ratio = 100


func _ready():
    refresh()


func refresh():
    sfx_slider.value = int(
        Database.audio_volume_sfx * setting_to_percentage_ratio
    )
    music_slider.value = int(
        Database.audio_volume_music * setting_to_percentage_ratio
    )


func _build_volume_percentage_display(value):
    return str(value) + '%'


func _on_music_volume_percentage_slider_drag_ended(value_changed: bool) -> void:
    if !value_changed:
        return

    _set_music_volume_from_slider()


func _on_music_volume_percentage_slider_value_changed(value):
    music_volume_percentage_display.text = _build_volume_percentage_display(
        value
    )


func _on_sfx_volume_percentage_slider_drag_ended(value_changed: bool) -> void:
    if !value_changed:
        audio_manager.on_sfx_volume_updated()
        return

    _set_sfx_volume_from_slider()

    audio_manager.on_sfx_volume_updated()


func _on_sfx_volume_percentage_slider_value_changed(value):
    sfx_volume_percentage_display.text = _build_volume_percentage_display(value)


func _slider_value_to_volume(slider_value: float) -> float:
    var rounded_percentage = roundf(slider_value)
    return rounded_percentage / setting_to_percentage_ratio


#region Set volume

func _set_music_volume_from_slider() -> void:
    var updated_volume = _slider_value_to_volume(music_slider.value)
    SoundManager.set_music_volume(updated_volume)
    Database.set_audio_volume_music(updated_volume)


func _set_sfx_volume_from_slider() -> void:
    var updated_volume = _slider_value_to_volume(sfx_slider.value)
    SoundManager.set_sound_volume(updated_volume)
    Database.set_audio_volume_sfx(updated_volume)

#endregion Set volume
