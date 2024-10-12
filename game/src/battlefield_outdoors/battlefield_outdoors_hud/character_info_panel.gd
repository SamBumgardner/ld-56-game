class_name CharacterInfoPanel extends PanelContainer

signal character_selected(character: Character, selected_state: bool)

const LOCK_TEXT: String = "Lock Current Action"
const UNLOCK_TEXT: String = "Unlock Current Action"
const UPGRADE_FORMAT: String = "Upgrades:\n%s"
const FADE_DURATION: float = .25
const FORCE_END_STEP_DURATION: float = FADE_DURATION * 3

@onready var portrait: TextureRect = $MC/VB/Summary/Portrait
@onready var name_label: Label = $MC/VB/Summary/VB/Name
@onready var upgrade_label: Label = $MC/VB/Summary/VB/PC/MC/UpgradeLevel
@onready var possible_die_results: Array[Node] = $MC/VB/Actions/ActionsContainer.get_children()
@onready var current_die_result: DieResult = $MC/VB/Current/CurrentAction/MC/HB/DieResult
@onready var lock_button: Button = $MC/VB/Current/LockButton
@onready var lock_display: Control = $MC/VB/Current/CurrentAction/LockedBorder
@onready var close_button: Button = $CloseButton

var displayed_character: Character
var target_character: Character

var just_doing_fadeout: bool

var display_transition_tween: Tween

func _ready() -> void:
    Database.die_slot_changed.connect(_on_die_slot_changed)
    lock_button.pressed.connect(_toggle_freeze)
    close_button.pressed.connect(_on_close_button)

func display_character(new_character: Character):
    if new_character == null:
        target_character = null
        _stop_tween(display_transition_tween)
        display_transition_tween = create_tween()
        _apply_fade_out_steps(display_transition_tween)
        just_doing_fadeout = true

    elif target_character != displayed_character and not just_doing_fadeout:
        target_character = new_character

    elif target_character != new_character:
        just_doing_fadeout = false
        target_character = new_character
        _stop_tween(display_transition_tween)
        display_transition_tween = create_tween()

        if visible:
            _apply_fade_out_steps(display_transition_tween)
        display_transition_tween.tween_callback(_update_displayed_data)
        _apply_fade_in_steps(display_transition_tween)

func _update_displayed_data():
    displayed_character = target_character
    portrait.texture = displayed_character.portrait
    name_label.text = displayed_character.name
    upgrade_label.text = UPGRADE_FORMAT % displayed_character.upgrade_level

    var possible_actions: Array[Action] = displayed_character.actions.get_all()
    for i: int in possible_die_results.size():
        var action: Action = null
        if i < possible_actions.size():
            action = possible_actions[i]
        possible_die_results[i].set_action(action)

    var character_die_slot: CharacterDieSlot = Database.get_die_slot_by_character(displayed_character)
    _update_die_slot_display(character_die_slot)

func _update_die_slot_display(die_slot: CharacterDieSlot) -> void:
    if die_slot != null:
        current_die_result.set_action(die_slot.last_roll_result)
        _set_locked_status(die_slot.is_frozen)
    else:
        current_die_result.set_action(null)
        _set_locked_status(false)

func _stop_tween(tween: Tween) -> void:
    if tween != null and tween.is_running():
        tween.kill()

func _apply_fade_in_steps(tween: Tween) -> Tween:
    tween.tween_callback(show)
    tween.tween_property(self, "modulate", Color.WHITE, FADE_DURATION)

    return tween

func _apply_fade_out_steps(tween: Tween) -> Tween:
    tween.tween_property(self, "modulate", Color.TRANSPARENT, modulate.a / Color.WHITE.a * FADE_DURATION)
    tween.tween_callback(hide)
    tween.tween_callback(_clear_displayed_character)

    return tween

func _clear_displayed_character() -> void:
    displayed_character = null
    just_doing_fadeout = false

func _set_locked_status(should_show: bool) -> void:
    lock_display.visible = should_show
    lock_button.text = UNLOCK_TEXT if should_show else LOCK_TEXT

func _on_die_slot_changed(die_slot: CharacterDieSlot) -> void:
    if die_slot.character == displayed_character:
        _update_die_slot_display(die_slot)

func _toggle_freeze() -> void:
    if displayed_character != null:
        Database.set_die_slot_frozen_status(
            displayed_character,
            not lock_display.visible # TODO: refactor. this is bad, but display's what I've got to work with.
        )

func _on_close_button() -> void:
    display_character(null)
    character_selected.emit(target_character, false)
