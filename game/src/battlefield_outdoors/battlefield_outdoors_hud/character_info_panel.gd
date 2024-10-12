class_name CharacterInfoPanel extends PanelContainer

const UPGRADE_FORMAT: String = "Upgrades:\n%s"
const FADE_DURATION: float = .25
const FORCE_END_STEP_DURATION: float = FADE_DURATION * 3

@onready var portrait: TextureRect = $MC/VB/Summary/Portrait
@onready var name_label: Label = $MC/VB/Summary/VB/Name
@onready var upgrade_label: Label = $MC/VB/Summary/VB/PC/MC/UpgradeLevel
@onready var possible_die_results: Array[Node] = $MC/VB/Actions/ActionsContainer.get_children()
@onready var current_die_result: DieResult = $MC/VB/CurrentAction/MC/HB/DieResult

var displayed_character: Character
var target_character: Character

var just_doing_fadeout: bool

var display_transition_tween: Tween

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
    if character_die_slot != null:
        current_die_result.set_action(character_die_slot.last_roll_result)
    else:
        current_die_result.set_action(null)

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
