class_name BattlefieldOutdoorsHud extends Control

signal initiate_charge_requested
signal dice_roll_requested

const NEW_REGION_MESSAGE_FORMAT_HEADER = "New region reached: %s"
const NEW_REGION_MESSAGE_FORMAT_HEAL = "[color=cyan]Repaired %s health![/color]"
const NEW_REGION_MESSAGE_FORMAT_ADDITIONAL_INFO = "\nRegional Modifiers:\n%s"
const NEW_REGION_DURATION = 20

const REROLL_FAIL_MESSAGE_LOCK = "Failed to shuffle unlocked actions.\nReason: ALL_LOCKED"
const REROLL_FAIL_MESSAGE_FUEL = "Failed to shuffle unlocked actions.\nReason: INSUFFICIENT_FUEL"
const REROLL_FAIL_DURATION = 2

@onready var audio_manager: AudioManager = $AudioManager
#@onready var barriers = $TopBar/Trackers/BarriersOvercomeTracker/Current
@onready var combat_math_formulas = CombatMathFormulas.new()
@onready var health_current = $TopBar/Trackers/HealthDisplay/MarginContainer/HBoxContainer/HealthCurrent
@onready var health_maximum = $TopBar/Trackers/HealthDisplay/MarginContainer/HBoxContainer/HealthMaximum
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
@onready var distance_remaining_display: DistanceRemainingDisplay = $DistanceRemainingDisplay

@onready var resource_displays: Array[ResourceDisplay] = [
    $TopBar/Trackers/MoneyDisplay,
    $TopBar/Trackers/FuelDisplay,
    $BottomInfoDisplay/Center/TopEdge/FuelDisplayMini,
    $DistanceRemainingDisplay
]

func _ready():
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

    Database.region_changed.connect(_on_region_changed)


func request_roll_preview_start() -> void:
    crew_actions_display.start_preview_reroll()

func request_roll_preview_stop() -> void:
    crew_actions_display.stop_preview_reroll()

func _on_mock_reroll_button_pressed() -> void:
    dice_roll_requested.emit()
    calculations_hud.refresh()
    total_power_display.refresh()

func _set_health_text(new_health: int, _old_health: int = 0) -> void:
    health_current.text = str(new_health)
    health_maximum.text = str(Database.war_transport_health_maximum)

func _on_region_changed(new_region: Region, segment_info: ScenarioSegment) -> void:
    var stringbuilder: PackedStringArray = []
    stringbuilder.append(NEW_REGION_MESSAGE_FORMAT_HEADER % new_region.region_name)
    if segment_info.arrival_bonus_heal != 0:
        stringbuilder.append(NEW_REGION_MESSAGE_FORMAT_HEAL % segment_info.arrival_bonus_heal)
    stringbuilder.append(NEW_REGION_MESSAGE_FORMAT_ADDITIONAL_INFO % new_region.gameplay_description)

    screen_notification.queue_notification(
        ScreenNotification.ScreenNotificationType.NOTIFY,
        "\n".join(stringbuilder),
        NEW_REGION_DURATION
    )

func _on_insufficient_fuel() -> void:
    screen_notification.display_notification(
        ScreenNotification.ScreenNotificationType.ERROR,
        REROLL_FAIL_MESSAGE_FUEL,
        REROLL_FAIL_DURATION
    )
    fuel_display._on_insufficient_resource()
    bottom_bar_fuel._on_insufficient_resource()

func _on_all_locked() -> void:
    screen_notification.display_notification(
        ScreenNotification.ScreenNotificationType.ERROR,
        REROLL_FAIL_MESSAGE_LOCK,
        REROLL_FAIL_DURATION,
    )
    
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
        distance_remaining_display,
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
        distance_remaining_display,
    ]
    for target: Control in fadein_targets:
        var fadein_tween: Tween = create_tween()
        fadein_tween.tween_callback(target.show)
        fadein_tween.tween_property(target, "modulate", Color.WHITE, duration)
    
    # hide total power display so it doesn't show while the new values are getting rolled
    total_power_display.hide_total_value()

func _enable_interaction(skip_delay: bool = false) -> void:
    # delay added here to account for auto die roll
    create_tween() \
        .tween_callback(reroll_button._set_disabled.bind(false)) \
        .set_delay(0.0 if skip_delay else reroll_button.reroll_cooldown)
    
    # delay added here to let the transport get closer to start position
    create_tween() \
        .tween_callback(func(): charge_button.disabled = false) \
        .set_delay(0.0 if skip_delay else reroll_button.reroll_cooldown)
    
    
    total_power_display.show_total_value()
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
    _charge_mode_fadeout(duration)


func _on_charge_impact(duration: float) -> void:
    combat_results_summary.display_combat_results()

func _on_charge_cooldown(duration: float) -> void:
    print("HUD charge cooldown", duration)
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
