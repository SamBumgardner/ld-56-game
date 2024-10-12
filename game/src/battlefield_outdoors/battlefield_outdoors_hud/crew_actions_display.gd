class_name CrewActionsDisplay extends MarginContainer

@onready var database: Database = $"/root/Database"
@onready var action_displays: Array[Node] = $PC/GC.get_children()

func _ready() -> void:
    refresh()
    database.die_slots_set.connect(refresh)

func refresh():
    var die_slots = database.current_character_die_slots

    for i in action_displays.size():
        if i < die_slots.size():
            action_displays[i].set_character_die_slot(die_slots[i])
        else:
            action_displays[i].set_character_die_slot(null)

func _on_character_selected(selected_character: Character, button_end_state: bool) -> void:
    for action_display in action_displays:
        if button_end_state:
            action_display.button.button_pressed = (
                action_display.character_die_slot != null
                and action_display.character_die_slot.character == selected_character 
            )
        else:
            action_display.button.button_pressed = false
