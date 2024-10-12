class_name CrewActionsDisplay extends MarginContainer

@onready var database: Database = $"/root/Database"
@onready var action_displays: Array[Node] = $PC/GC.get_children()

func _ready() -> void:
    refresh()

func refresh():
    var die_slots = database.current_character_die_slots

    for i in action_displays.size():
        if i < die_slots.size():
            action_displays[i].set_character_die_slot(die_slots[i])
        else:
            action_displays[i].set_character_die_slot(null)
