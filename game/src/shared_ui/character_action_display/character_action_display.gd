class_name CharacterActionDisplay extends TextureRect

signal character_selected(character: Character, button_end_state: bool)
signal character_hover_changed(character: Character, is_hovered: bool)

@onready var audio_manager: AudioManager = $AudioManager
@onready var die_result: DieResult = $DieResult
@onready var frozen_background: Control = $FrozenBackground
@onready var frozen_icon: TextureRect = $FrozenIcon
@onready var button: Button = $Button
@onready var value_changed_particles: CPUParticles2D = $Control/ValueChangedParticles

var character_die_slot: CharacterDieSlot

var rolling_display: bool
var rolling_tween: Tween

func _ready() -> void:
    button.gui_input.connect(_handle_freeze_roll_action)
    button.pressed.connect(_on_button_pressed)
    button.mouse_entered.connect(_on_button_hovered)
    button.mouse_exited.connect(_on_button_hovered)
    Database.die_slot_changed.connect(_on_die_slot_update)

func refresh(trigger_particles: bool = false) -> void:
    if character_die_slot != null:
        if trigger_particles:
            value_changed_particles.restart()

        texture = character_die_slot.character.icon
        die_result.set_action(character_die_slot.last_roll_result)
        show()
        if character_die_slot.is_frozen:
            frozen_background.show()
            frozen_icon.show()
        else:
            frozen_background.hide()
            frozen_icon.hide()
    else:
        hide()

func set_character_die_slot(new_die_slot: CharacterDieSlot, display_particles: bool = false) -> void:
    character_die_slot = new_die_slot
    refresh(display_particles)

func toggle_freeze() -> void:
    if character_die_slot == null:
        print_debug(
            'Failed to toggle_freeze due to a'
            + ' missing character_die_slot reference.'
        )
        return

    audio_manager.on_toggle_freeze()
    Database.set_die_slot_frozen_status(
        character_die_slot.character,
        not character_die_slot.is_frozen
    )

func _handle_freeze_roll_action(event: InputEvent):
    if event.is_action_pressed("freeze_roll") and not button.disabled:
        toggle_freeze()
        get_viewport().set_input_as_handled()

func _on_button_pressed() -> void:
    character_selected.emit(character_die_slot.character, button.button_pressed)

func _on_button_hovered() -> void:
    if character_die_slot == null:
        print_debug(
            'Failed to hover due to a'
            + ' missing character_die_slot reference.'
        )
        return

    character_hover_changed.emit(character_die_slot.character, button.is_hovered())

func _on_die_slot_update(changed_die_slot: CharacterDieSlot) -> void:
    if changed_die_slot == character_die_slot:
        refresh()

func _process(_delta: float):
    if rolling_display and character_die_slot != null and not character_die_slot.is_frozen:
        _set_up_rolling_tween()

    if ((not rolling_display or (character_die_slot != null and character_die_slot.is_frozen))
            and (rolling_tween != null and rolling_tween.is_running())):
        rolling_tween.stop()
        refresh()

func _set_up_rolling_tween():
    if rolling_tween == null or not rolling_tween.is_valid():
        rolling_tween = create_tween()
        rolling_tween.set_loops()
        rolling_tween.tween_method(_cycle_die_result_display, 0.0, 1.0, .5)
    elif not rolling_tween.is_running():
        rolling_tween.play()

func _cycle_die_result_display(rand_value: float) -> void:
    var actions: Array[Action] = character_die_slot.character.actions.get_all()
    var action_index: int = ceil(rand_value * actions.size()) - 1
    die_result.set_action(actions[action_index])

func set_rolling_display(new_rolling_display: bool):
    rolling_display = new_rolling_display

func disable() -> void:
    button.disabled = true

func enable() -> void:
    button.disabled = false
