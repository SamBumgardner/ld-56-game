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
    sfx_slider.value = int(
        SoundManager.get_sound_volume() * setting_to_percentage_ratio
    )
    music_slider.value = int(
        SoundManager.get_music_volume() * setting_to_percentage_ratio
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

    SoundManager.set_sound_volume(
        roundf(music_slider.value) / setting_to_percentage_ratio
    )
    print_debug('Updated music volume: ', SoundManager.get_sound_volume())


func _on_sfx_volume_percentage_slider_drag_ended(value_changed):
    if !value_changed:
        audio_manager.on_sfx_volume_updated()
        return

    SoundManager.set_sound_volume(
        roundf(sfx_slider.value) / setting_to_percentage_ratio
    )

    audio_manager.on_sfx_volume_updated()
    print_debug('Updated sound volume: ', SoundManager.get_sound_volume())


func _on_music_volume_percentage_slider_value_changed(value):
    music_volume_percentage_display.text = str(value) + '%'


func _on_sfx_volume_percentage_slider_value_changed(value):
    sfx_volume_percentage_display.text = str(value) + '%'
