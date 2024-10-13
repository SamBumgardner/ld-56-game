class_name BattlefieldOutdoorsHud extends Control

signal initiate_charge_requested
signal dice_roll_requested

const REROLL_FAIL_MESSAGE = "Failed to shuffle unlocked actions.\nReason: INSUFFICIENT_FUEL"
const REROLL_FAIL_DURATION = 2

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

func _ready():
    _hide_warnings()

    _set_health_text()

    for crew_selector_button in crew_member_selector.crew_selector_buttons:
        crew_selector_button.character_selected.connect(crew_actions_display._on_character_selected)
        crew_selector_button.character_selected.connect(_on_character_selection_changed)

    for character_action_display in crew_actions_display.action_displays:
        character_action_display.character_selected.connect(crew_member_selector._on_character_selected)
        character_action_display.character_selected.connect(_on_character_selection_changed)
    
    character_info_panel.character_selected.connect(crew_member_selector._on_character_selected)
    character_info_panel.character_selected.connect(crew_actions_display._on_character_selected)

    reroll_button.hovered_available_reroll.connect(crew_actions_display._start_preview_reroll)
    reroll_button.exited_available_reroll.connect(crew_actions_display._stop_preview_reroll)
 
    charge_button.pressed.connect(initiate_charge_requested.emit)

# Sum dice results, multiplying dice that match the target StatType.
func _get_war_transport_damage_reduction_amount() -> int:
    return combat_math_formulas.total_dice_with_matching_stat_type_multiplier(
        Database.current_character_die_slots,
        Database.current_barrier_stat_type_to_overcome,
        Database.current_matching_stat_type_multiplier
    )


func _hide_warnings() -> void:
    warning_out_of_health.visible = false
    _hide_roll_warnings()


func _hide_roll_warnings() -> void:
    warning_only_frozen_troops.visible = false
    warning_out_of_troops.visible = false


func _on_mock_attack_button_pressed() -> void:
    _hide_roll_warnings()

    if Database.war_transport_health_current <= 0:
        warning_out_of_health.visible = true
        return

    print_debug('War transport rams into the barrier.')

    var updated_health = Database.war_transport_health_current

    var war_transport_damage_reduction_amount = (
        _get_war_transport_damage_reduction_amount()
    )
    var damage_amount = (
        Database.current_barrier_cost_to_overcome_number
        - war_transport_damage_reduction_amount
    )

    if damage_amount > 0:
        _reduce_war_transport_health(damage_amount)

    if updated_health > 0:
        #barriers.text = str(Database.barriers_overcome_count)
        return

    print_debug('Game over, health has reached ', updated_health)
    warning_out_of_health.visible = true


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


func _reduce_war_transport_health(amount_to_subtract : int) -> int:
    var updated_health = (
        Database.war_transport_health_current
        - amount_to_subtract
    )
    Database.set_war_transport_health_current(
        updated_health
    )
    _set_health_text()
    return updated_health




func _set_health_text() -> void:
    health_current.text = str(Database.war_transport_health_current)
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
        create_tween().tween_property(target, "modulate", Color.TRANSPARENT, duration)
    
func _charge_mode_fadein(duration: float) -> void:
    var fadein_targets: Array[Control] = [
        bottom_info_display,
        screen_notification,
        go_inside_button,
        top_bar_display,
    ]
    for target: Control in fadein_targets:
        create_tween().tween_property(target, "modulate", Color.WHITE, duration)

func _enable_interaction() -> void:
    reroll_button._set_disabled(false)
    charge_button.disabled = false
    go_inside_button.disabled = false
    # fade in hud, more quickly this time
    crew_actions_display.enable_all()
    crew_member_selector.enable_all()

func _on_charge_start() -> void:
    print("HUD charge start")
    _disable_interaction()

func _on_charge_warmup(duration: float) -> void:
    print("HUD charge warmup", duration)
    _charge_mode_fadeout(duration)

func _on_charge_action(duration: float) -> void:
    print("HUD charge action", duration)

func _on_charge_impact(duration: float) -> void:
    print("HUD charge impact", duration)
    # health reduced

func _on_charge_cooldown(duration: float) -> void:
    print("HUD charge cooldown", duration)
    # trigger refreshes & information updates
    _charge_mode_fadein(duration)

func _on_charge_finish() -> void:
    _enable_interaction()
