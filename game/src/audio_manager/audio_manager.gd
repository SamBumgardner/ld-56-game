# Play audio triggered by signals.
extends Node


const _default_volumes: float = 0.5


func _ready():
    if Database.audio_volume_initialized:
        return

    Database.set_audio_volume_initialized(true)

    SoundManager.set_ambient_sound_volume(_default_volumes)
    SoundManager.set_music_volume(_default_volumes)
    SoundManager.set_sound_volume(_default_volumes)
