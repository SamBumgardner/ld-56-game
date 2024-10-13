class_name CrewActionsDisplay extends MarginContainer

@onready var database: Database = $"/root/Database"
@onready var action_displays: Array[Node] = $PC/GC.get_children()

func _ready() -> void:
    refresh()
    database.die_slots_set.connect(refresh)

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

func _start_preview_reroll() -> void:
    for action_display in action_displays:
        action_display.set_rolling_display(true)

func _stop_preview_reroll() -> void:
    for action_display in action_displays:
        action_display.set_rolling_display(false)

func disable_all() -> void:
    for action_display in action_displays:
        action_display.disable()

func enable_all() -> void:
    for action_display in action_displays:
        action_display.enable()
