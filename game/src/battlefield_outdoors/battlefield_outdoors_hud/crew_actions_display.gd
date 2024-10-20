class_name CrewActionsDisplay extends Control

signal dice_visually_rolling_start()
signal dice_visually_rolling_stop()

@onready var database: Database = $"/root/Database"
var action_displays: Array[Node]

func _ready() -> void:
    action_displays = _get_child_action_displays()
    refresh()
    database.die_slots_set.connect(refresh)

func _get_child_action_displays() -> Array[Node]:
    return $PC/GC.get_children()

func refresh(was_reroll: bool = false):
    var die_slots: Array[CharacterDieSlot] = database.current_character_die_slots

    for i in action_displays.size():
        if i < die_slots.size():
            var display_particles: bool = was_reroll and not die_slots[i].is_frozen
            action_displays[i].set_character_die_slot(die_slots[i], display_particles)
        else:
            action_displays[i].set_character_die_slot(null)
        action_displays[i].button.button_pressed = false

func _on_character_selected(selected_character: Character, button_end_state: bool) -> void:
    for action_display in action_displays:
        if button_end_state:
            action_display.button.button_pressed = (
                action_display.character_die_slot != null
                and action_display.character_die_slot.character == selected_character
            )
        else:
            action_display.button.button_pressed = false

func _on_character_hovered(selected_character: Character, is_hovered: bool):
    for action_display in action_displays:
        if (action_display.character_die_slot != null
                and action_display.character_die_slot.character == selected_character
                ):
            if is_hovered:
                action_display.modulate = Color.WHITE
            else:
                action_display.modulate = Color.YELLOW

func start_preview_reroll() -> void:
    var any_unfrozen: bool = false
    for action_display in action_displays:
        action_display.set_rolling_display(true)
        if (action_display.character_die_slot != null
                and not action_display.character_die_slot.is_frozen):
            any_unfrozen = true
    
    if any_unfrozen:
        dice_visually_rolling_start.emit()

func stop_preview_reroll() -> void:
    for action_display in action_displays:
        action_display.set_rolling_display(false)

    dice_visually_rolling_stop.emit()

func disable_all() -> void:
    for action_display in action_displays:
        action_display.button.button_pressed = false
        action_display.disable()

func enable_all() -> void:
    for action_display in action_displays:
        action_display.enable()
