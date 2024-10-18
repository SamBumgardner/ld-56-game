class_name BattlefieldOutdoorsHud extends Control

signal initiate_charge_requested
signal dice_roll_requested

const REROLL_FAIL_MESSAGE = "Failed to shuffle unlocked actions.\nReason: INSUFFICIENT_FUEL"
const REROLL_FAIL_DURATION = 2

@onready var audio_manager: AudioManager = $AudioManager
#@onready var barriers = $TopBar/Trackers/BarriersOvercomeTracker/Current
@onready var combat_math_formulas = CombatMathFormulas.new()
@onready var health_current = $TopBar/Trackers/HealthDisplay/MarginContainer/HBoxContainer/HealthCurrent
@onready var health_maximum = $TopBar/Trackers/HealthDisplay/MarginContainer/HBoxContainer/HealthMaximum
@onready var warning_only_frozen_troops = (
    $CentralControls/VBoxContainer/Warnings/WarningOnlyFrozenTroops
)
@onready var warning_out_of_health = (
    $CentralControls/VBoxContainer/Warnings/WarningOutOfHealth
)
@onready var warning_out_of_troops = (
    $CentralControls/VBoxContainer/Warnings/WarningOutOfTroops
)
@onready var bottom_info_display: Control = $BottomInfoDisplay
@onready var top_bar_display: Control = $TopBar
@onready var screen_notification: ScreenNotification = $ScreenNotification
@onready var character_info_panel: CharacterInfoPanel = $CharacterInfoPanel
@onready var crew_member_selector: CrewMemberSelector = $BottomInfoDisplay/Left/CrewMemberSelector
@onready var fuel_display: FuelDisplay = $TopBar/Trackers/FuelDisplay
@onready var bottom_bar_fuel: FuelDisplay = $BottomInfoDisplay/Center/TopEdge/FuelDisplayMini
@onready var crew_actions_display: CrewActionsDisplay = $BottomInfoDisplay/Center/CrewStatus/StatusSections/CrewActionsDisplay
@onready var calculations_hud: CombatMathCalculationsHud = $BottomInfoDisplay/Center/CrewStatus/StatusSections/CalculationsDisplay/CombatMathCalculationsHud
@onready var barrier_preview: BarrierPreview = $BottomInfoDisplay/Right/BarrierPreview
@onready var total_power_display: TotalPowerDisplay = $BottomInfoDisplay/Center/CrewStatus/StatusSections/TotalPowerDisplay
@onready var reroll_button: RerollButton = $BottomInfoDisplay/Center/TopEdge/RerollButton
@onready var charge_button: Button = $BottomInfoDisplay/Center/CrewStatus/StatusSections/TotalPowerDisplay/PanelContainer/VBoxContainer/ChargeButton
@onready var go_inside_button: Button = $GoInsideButton
@onready var combat_results_summary: CombatResultsSummary = $CombatResultsSummary

@onready var resource_displays: Array[ResourceDisplay] = [
    $TopBar/Trackers/MoneyDisplay,
    $TopBar/Trackers/FuelDisplay,
    $BottomInfoDisplay/Center/TopEdge/FuelDisplayMini,
]

func _ready():
    _hide_warnings()

    _set_health_text(Database.war_transport_health_current)
    Database.health_changed.connect(_set_health_text)

    for crew_selector_button in crew_member_selector.crew_selector_buttons:
        crew_selector_button.character_selected.connect(crew_actions_display._on_character_selected)
        crew_selector_button.character_selected.connect(_on_character_selection_changed)

    for character_action_display in crew_actions_display.action_displays:
        character_action_display.character_selected.connect(crew_member_selector._on_character_selected)
        character_action_display.character_selected.connect(_on_character_selection_changed)
    
    character_info_panel.character_selected.connect(crew_member_selector._on_character_selected)
    character_info_panel.character_selected.connect(crew_actions_display._on_character_selected)

    reroll_button.hovered_available_reroll.connect(crew_actions_display.start_preview_reroll)
    reroll_button.exited_available_reroll.connect(crew_actions_display.stop_preview_reroll)
 
    charge_button.pressed.connect(initiate_charge_requested.emit)

func _hide_warnings() -> void:
    warning_out_of_health.visible = false
    _hide_roll_warnings()


func _hide_roll_warnings() -> void:
    warning_only_frozen_troops.visible = false
    warning_out_of_troops.visible = false


func _on_mock_attack_button_pressed() -> void:
    _hide_roll_warnings()

func request_roll_preview_start() -> void:
    crew_actions_display.start_preview_reroll()

func request_roll_preview_stop() -> void:
    crew_actions_display.stop_preview_reroll()

func _on_mock_reroll_button_pressed() -> void:
    if Database.war_transport_health_current <= 0:
        print_debug('Player requested a roll without any health.')
        return

    if Database.hired_characters.size() == 0:
        print_debug('Player requested a roll without any troops.')
        warning_out_of_troops.visible = true
        return

    if Database.current_character_die_slots.all(
        func(character_die_slot: CharacterDieSlot) -> bool: return (
            character_die_slot.is_frozen
        )
    ):
        print_debug('Player requested a roll with only frozen troops.')
        warning_only_frozen_troops.visible = true
        return

    # Player is rolling at least one character die.
    _hide_roll_warnings()

    dice_roll_requested.emit()
    calculations_hud.refresh()
    total_power_display.refresh()

func _set_health_text(new_health: int, _old_health: int = 0) -> void:
    health_current.text = str(new_health)
    health_maximum.text = str(Database.war_transport_health_maximum)

func _on_insufficient_fuel() -> void:
    screen_notification.display_notification(
        ScreenNotification.ScreenNotificationType.ERROR,
        REROLL_FAIL_MESSAGE,
        REROLL_FAIL_DURATION
    )
    fuel_display._on_insufficient_resource()
    bottom_bar_fuel._on_insufficient_resource()
    
func refresh_calculations() -> void:
    calculations_hud.refresh()
    total_power_display.refresh()
    character_info_panel.refresh()

func _on_character_selection_changed(character: Character, selected_state: bool) -> void:
    if selected_state:
        character_info_panel.display_character(character)
    else:
        character_info_panel.display_character(null)

func _disable_interaction() -> void:
    reroll_button._set_disabled(true)
    charge_button.disabled = true
    go_inside_button.disabled = true
    # implement "turn off" actions here
    crew_actions_display.disable_all()
    crew_member_selector.disable_all()
    character_info_panel.display_character(null)

func _charge_mode_fadeout(duration: float) -> void:
    var fadeout_targets: Array[Control] = [
        bottom_info_display,
        screen_notification,
        go_inside_button,
        top_bar_display,
    ]
    for target: Control in fadeout_targets:
        var fadeout_tween: Tween = create_tween()
        fadeout_tween.tween_property(target, "modulate", Color.TRANSPARENT, duration)
        fadeout_tween.tween_callback(target.hide)
    
func _charge_mode_fadein(duration: float) -> void:
    var fadein_targets: Array[Control] = [
        bottom_info_display,
        screen_notification,
        go_inside_button,
        top_bar_display,
    ]
    for target: Control in fadein_targets:
        var fadein_tween: Tween = create_tween()
        fadein_tween.tween_callback(target.show)
        fadein_tween.tween_property(target, "modulate", Color.WHITE, duration)

func _enable_interaction() -> void:
    # delay added here to account for auto die roll
    create_tween() \
        .tween_callback(reroll_button._set_disabled.bind(false)) \
        .set_delay(reroll_button.reroll_cooldown)
    
    charge_button.disabled = false
    go_inside_button.disabled = false
    # fade in hud, more quickly this time
    crew_actions_display.enable_all()
    crew_member_selector.enable_all()

## Want to save the "resource ticking up" stuff until after the elements are visible again.
func increase_resource_update_delay() -> void:
    for resource_display: ResourceDisplay in resource_displays:
        resource_display.resource_change_start_delay = ChargeSequence.COOLDOWN_DURATION + ChargeSequence.IMPACT_DURATION

func unset_resource_update_delay() -> void:
    for resource_display: ResourceDisplay in resource_displays:
        resource_display.resource_change_start_delay = 0

func set_combat_results(combat_results: CombatResultsSummary.CombatResult) -> void:
    combat_results_summary.set_combat_results_bundled(combat_results)

func _on_charge_start() -> void:
    print("HUD charge start")
    _disable_interaction()
    increase_resource_update_delay()

func _on_charge_warmup(duration: float) -> void:
    print("HUD charge warmup", duration)
    _charge_mode_fadeout(duration)

func _on_charge_action(duration: float) -> void:
    print("HUD charge action", duration)

func _on_charge_impact(duration: float) -> void:
    print("HUD charge impact", duration)
    combat_results_summary.display_combat_results()
    # health reduced

func _on_charge_cooldown(duration: float) -> void:
    print("HUD charge cooldown", duration)
    # trigger refreshes & information updates
    _charge_mode_fadein(duration)

func _on_charge_finish() -> void:
    unset_resource_update_delay()
    _enable_interaction()


#region Descendant SFX: enabled button mouse entered

func _on_charge_button_mouse_entered():
    if charge_button.disabled:
        return

    audio_manager.on_enabled_button_mouse_entered()

func _on_go_inside_button_mouse_entered():
    if go_inside_button.disabled:
        return

    audio_manager.on_enabled_button_mouse_entered()

func _on_reroll_button_mouse_entered():
    if reroll_button.disabled:
        return

    audio_manager.on_enabled_button_mouse_entered()

#endregion Descendant SFX: enabled button mouse entered
