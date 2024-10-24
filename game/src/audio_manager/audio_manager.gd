# Play audio triggered by signals.
class_name AudioManager extends Node

@export var background_music_default: AudioStream
@export var background_music_queue: Array[AudioStream]

@export var sfx_button_click: AudioStream
@export var sfx_button_hover: AudioStream
@export var sfx_dice_landing: AudioStream
@export var sfx_dice_shake: AudioStream
@export var sfx_die_lock: AudioStream
@export var sfx_enter_next_region: AudioStream
@export var sfx_game_victory: AudioStream
@export var sfx_indoors_enter_a_menu: AudioStream
@export var sfx_indoors_exit_a_menu: AudioStream
@export var sfx_notification_error: AudioStream
@export var sfx_transition_gameplay_indoors_to_outdoors: AudioStream
@export var sfx_transition_gameplay_outdoors_to_indoors: AudioStream
@export var sfx_war_transport_charge_crush: AudioStream
@export var sfx_war_transport_charge_forward: AudioStream
@export var sfx_war_transport_charge_lose: AudioStream
@export var sfx_little_fanfare: AudioStream
@export var sfx_final_fanfare: AudioStream


const _bus_name_music = 'Music'
const _bus_name_sfx_ui = 'SFX UI'
const _default_audio_crossfade = 0.1
const _charge_audio_crossfade = 0
const _reroll_audio_crossfade = 0.5
const _background_audio_crossfade = 2.0


func _ready():
    if !Database.audio_volume_initialized:
        Database.set_audio_volume_initialized(true)

    SoundManager.set_default_music_bus(_bus_name_music)
    SoundManager.set_default_ambient_sound_bus(_bus_name_sfx_ui)

    SoundManager.set_ambient_sound_volume(Database.audio_volume_sfx)
    SoundManager.set_music_volume(Database.audio_volume_music)
    

# Listen for a custom signal in order to ignore hovering over a disabled button.
func on_charge_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)


# Listen for a custom signal in order to delay until volume is updated.
func on_sfx_volume_updated():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)


# Listen for a custom signal in order to ignore hovering over disabled buttons.
func on_enabled_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)


# Listen for a custom signal in order to reuse layering of button connections
#  that detect a right click signal.
func on_toggle_freeze():
    SoundManager.play_ui_sound(sfx_die_lock, _bus_name_sfx_ui)


# After leaving the start menu, start playing the background music.
# Call it while music is already playing to go to the next song.
func _start_background_music(force_next: bool = false, fade_override: float = 0):
    var fade_duration: float = 0.0
    var current_music_index: int = Database.current_background_music_index
    
    if SoundManager.is_music_playing() or force_next:
        current_music_index = (current_music_index + 1) % background_music_queue.size()
        fade_duration = _background_audio_crossfade
    
    if fade_override != 0:
        fade_duration = fade_override

    var next_track: AudioStream = background_music_queue[current_music_index]

    SoundManager.play_music(next_track, fade_duration)
    Database.set_current_background_music_index(current_music_index)


#region Button mouse entered

func _on_back_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_character_info_panel_close_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_close_screen_notification_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_crew_member_detail_exit_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_crew_selector_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_exit_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_go_outside_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_hire_detail_exit_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_hire_preview_display_cancel_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_lock_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_new_hire_preview_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_purchase_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_quit_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_reset_to_defaults_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_settings_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_start_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_to_main_menu_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_toggle_background_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_upgrade_choice_display_upgrade_hovered(
    _upgrade,
    _upgrade_level_purchased,
    _this_purchased
):
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

#endregion Button mouse entered


#region Button press

func _on_browse_new_hires_button_pressed():
    SoundManager.play_ui_sound(sfx_indoors_enter_a_menu, _bus_name_sfx_ui)

func _on_character_info_panel_close_button_pressed():
    SoundManager.play_ui_sound(sfx_indoors_exit_a_menu, _bus_name_sfx_ui)

func _on_charge_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_close_screen_notification_button_pressed():
    SoundManager.play_ui_sound(sfx_indoors_exit_a_menu, _bus_name_sfx_ui)

func _on_crew_member_detail_exit_button_pressed():
    SoundManager.play_ui_sound(sfx_indoors_exit_a_menu, _bus_name_sfx_ui)

func _on_exit_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_go_inside_button_pressed():
    SoundManager.play_ui_sound(
        sfx_transition_gameplay_outdoors_to_indoors,
        _bus_name_sfx_ui
    )

func _on_go_outside_button_pressed():
    SoundManager.play_ui_sound(
        sfx_transition_gameplay_indoors_to_outdoors,
        _bus_name_sfx_ui
    )

func _on_hire_detail_exit_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_hire_preview_display_cancel_button_pressed():
    SoundManager.play_ui_sound(sfx_indoors_exit_a_menu, _bus_name_sfx_ui)

func _on_lock_button_pressed():
    SoundManager.play_ui_sound(sfx_die_lock, _bus_name_sfx_ui)

func _on_new_hire_preview_button_pressed():
    SoundManager.play_ui_sound(sfx_indoors_enter_a_menu, _bus_name_sfx_ui)

func _on_purchase_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_quit_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_retry_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_settings_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_start_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_to_main_menu_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_toggle_background_button_pressed():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_upgrade_choice_display_upgrade_selected(
    _upgrade,
    _upgrade_level_purchased,
    _this_purchased
):
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

#endregion Button press


#region Character upgrade

func _on_indoor_preparation_upgrade_success(character):
    if character.sfx_upgrade_gained == null:
        SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)
        return

    SoundManager.play_ui_sound(character.sfx_upgrade_gained, _bus_name_sfx_ui)

#endregion Character upgrade


#region Character select

# Include a click SFX whether or not a character specific SFX is also played.
func _on_character_action_display_character_selected(_character, _button_end_state):
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_crew_button_crew_member_selected(character: Character):
    if character.sfx_hello == null:
        SoundManager.play_ui_sound(sfx_indoors_enter_a_menu, _bus_name_sfx_ui)
        return

    SoundManager.play_ui_sound(character.sfx_hello, _bus_name_sfx_ui)

func _on_crew_selector_button_character_selected(_character, _button_end_state):
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

#endregion


#region Dice reroll hovering

func _on_battlefield_outdoors_dice_roll_started():
    SoundManager.play_ambient_sound(
        sfx_dice_landing,
        _default_audio_crossfade,
        _bus_name_sfx_ui
    )

# 2024-10-13 Known edge case: Due to the crossfade greater than 0,
#  quickly leaving and then re-entering focus will stop the sound effect.
func _on_crew_actions_display_dice_visually_rolling_start():
    SoundManager.play_ambient_sound(
        sfx_dice_shake,
        _reroll_audio_crossfade,
        _bus_name_sfx_ui,
        true
    )

func _on_crew_actions_display_dice_visually_rolling_stop():
    SoundManager.stop_ambient_sound(sfx_dice_shake, _reroll_audio_crossfade)

#endregion Dice reroll hovering


#region Notification

func _on_indoor_preparation_insufficient_funds():
    SoundManager.play_ui_sound(sfx_notification_error, _bus_name_sfx_ui)

#endregion Notification


#region Scene arrival

func _on_settings_menu_ready():
    _start_background_music()

func _on_start_menu_ready():
    if Database.audio_game_start_background_music_initialized:
        return

    Database.set_audio_game_start_background_music_initialized(true)
    _start_background_music()

#endregion Scene arrival


#region Scene cleanup

# Stop looping gameplay sounds.
func _on_gameplay_tree_exiting():
    SoundManager.stop_ambient_sound(sfx_dice_shake, _reroll_audio_crossfade)

#endregion Scene cleanup


#region Slider drag ended

func _on_music_volume_percentage_slider_drag_ended(_value_changed):
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

#endregion Slider drag ended


#region War transport charge

func _on_battlefield_outdoors_charge_impact(_duration):
    SoundManager.play_ambient_sound(
        sfx_war_transport_charge_crush,
        _charge_audio_crossfade,
        _bus_name_sfx_ui
    )

func _on_battlefield_outdoors_charge_warmup(_duration):
    SoundManager.play_ambient_sound(
        sfx_war_transport_charge_forward,
        _charge_audio_crossfade,
        _bus_name_sfx_ui
    )

func _on_battlefield_outdoors_health_empty():
    SoundManager.play_ui_sound(sfx_war_transport_charge_lose, _bus_name_sfx_ui)

#endregion War transport charge


#region Objectives Achieved

func _play_little_fanfare():
    SoundManager.play_ambient_sound(
        sfx_little_fanfare,
        _default_audio_crossfade,
        _bus_name_sfx_ui
    )


func _play_final_fanfare():
    SoundManager.play_ambient_sound(
        sfx_final_fanfare,
        _default_audio_crossfade,
        _bus_name_sfx_ui
    )
    
    
func _on_battlefield_outdoors_milestone_achieved() -> void:
    const fadeout_before_fanfare_duration: float = .5

    var fanfare_sequence_tween: Tween = create_tween()
    fanfare_sequence_tween.tween_callback(SoundManager.stop_music.bind(fadeout_before_fanfare_duration))
    fanfare_sequence_tween.tween_interval(fadeout_before_fanfare_duration)
    fanfare_sequence_tween.tween_callback(_play_little_fanfare)
    fanfare_sequence_tween.tween_interval(max(sfx_little_fanfare.get_length() - _background_audio_crossfade / 2, 0))
    fanfare_sequence_tween.tween_callback(_start_background_music.bind(true))


func _on_battlefield_outdoors_victory(_duration: float) -> void:
    const fadeout_before_fanfare_duration: float = .5

    var victory_sequence_tween: Tween = create_tween()
    victory_sequence_tween.tween_callback(SoundManager.stop_music.bind(fadeout_before_fanfare_duration))
    victory_sequence_tween.tween_interval(fadeout_before_fanfare_duration)
    victory_sequence_tween.tween_callback(_play_final_fanfare)

    # the credits screen will take care of playing music again when it's loaded.

func _on_victory_scene_ready() -> void:
    const play_next_track: bool = true
    const victory_fade_in_duration: float = 5.0

    _start_background_music(play_next_track, victory_fade_in_duration)

#endregion
