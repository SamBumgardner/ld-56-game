# Play audio triggered by signals.
class_name AudioManager extends Node

@export var background_music_default: AudioStream

@export var sfx_button_click: AudioStream
@export var sfx_button_hover: AudioStream
@export var sfx_dice_landing: AudioStream
@export var sfx_dice_shake: AudioStream
@export var sfx_indoors_enter_a_menu: AudioStream
@export var sfx_indoors_exit_a_menu: AudioStream
@export var sfx_transition_gameplay_indoors_to_outdoors: AudioStream
@export var sfx_transition_gameplay_outdoors_to_indoors: AudioStream
@export var sfx_war_transport_charge_crush: AudioStream
@export var sfx_war_transport_charge_forward: AudioStream
@export var sfx_war_transport_charge_idle: AudioStream


const _bus_name_music = 'Music'
const _bus_name_sfx_ui = 'SFX UI'
const _default_audio_crossfade = 0.1
const _charge_audio_crossfade = 0
const _reroll_audio_crossfade = 0


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
    SoundManager.play_ambient_sound(
        sfx_war_transport_charge_idle,
        _charge_audio_crossfade,
        _bus_name_sfx_ui
    )


# Exit method as a companion to an enter method.
func on_charge_button_mouse_exited():
    SoundManager.stop_ambient_sound(
        sfx_war_transport_charge_idle,
        _reroll_audio_crossfade
    )


# Listen for a custom signal in order to delay until volume is updated.
func on_sfx_volume_updated():
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)


# Listen for a custom signal in order to ignore hovering over disabled buttons.
func on_enabled_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)


# After leaving the start menu, start playing the background music.
func _start_background_music():
    if SoundManager.is_music_playing():
        return

    SoundManager.play_music(background_music_default)


#region Button mouse entered

func _on_back_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_character_info_panel_close_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_close_screen_notification_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_crew_member_detail_exit_button_mouse_entered():
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

func _on_retry_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_settings_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_start_button_mouse_entered():
    SoundManager.play_ui_sound(sfx_button_hover, _bus_name_sfx_ui)

func _on_to_main_menu_mouse_entered():
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
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

func _on_new_hire_preview_button_pressed():
    SoundManager.play_ui_sound(sfx_indoors_enter_a_menu, _bus_name_sfx_ui)

# Reused for 2 buttons.
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

#endregion Button press


#region Character select
# Selecting a character is treated like a menu navigation SFX for simplicity.

func _on_crew_button_crew_member_selected(_character):
    SoundManager.play_ui_sound(sfx_indoors_enter_a_menu, _bus_name_sfx_ui)

func _on_crew_selector_button_character_selected(_character, _button_end_state):
    SoundManager.play_ui_sound(sfx_indoors_enter_a_menu, _bus_name_sfx_ui)

func _on_character_action_display_character_selected(_character, _button_end_state):
    SoundManager.play_ui_sound(sfx_indoors_enter_a_menu, _bus_name_sfx_ui)

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
        _bus_name_sfx_ui
    )

func _on_crew_actions_display_dice_visually_rolling_stop():
    SoundManager.stop_ambient_sound(sfx_dice_shake, _reroll_audio_crossfade)

    SoundManager.stop_ambient_sound(
        sfx_war_transport_charge_idle,
        _reroll_audio_crossfade
    )

#endregion Dice reroll hovering


#region Scene arrival

func _on_gameplay_ready():
    _start_background_music()

func _on_settings_menu_ready():
    _start_background_music()

#endregion Scene arrival


#region Scene cleanup

# Stop looping gameplay sounds.
func _on_gameplay_tree_exiting():
    SoundManager.stop_ambient_sound(sfx_dice_shake, _reroll_audio_crossfade)
    SoundManager.stop_ambient_sound(
        sfx_war_transport_charge_idle,
        _reroll_audio_crossfade
    )

#endregion Scene cleanup


#region Slider drag ended

func _on_music_volume_percentage_slider_drag_ended(_value_changed):
    SoundManager.play_ui_sound(sfx_button_click, _bus_name_sfx_ui)

#endregion Slider drag ended


#region War transport charge

func _on_battlefield_outdoors_charge_impact(duration):
    SoundManager.play_ambient_sound(
        sfx_war_transport_charge_crush,
        _charge_audio_crossfade,
        _bus_name_sfx_ui
    )

func _on_battlefield_outdoors_charge_warmup(duration):
    SoundManager.play_ambient_sound(
        sfx_war_transport_charge_forward,
        _charge_audio_crossfade,
        _bus_name_sfx_ui
    )

#endregion War transport charge
