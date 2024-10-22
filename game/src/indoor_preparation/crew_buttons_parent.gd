class_name CrewButtonsParent extends Control

@onready var crew_buttons: Array[Node] = get_children().filter(func(x): return x.get_script() != null)

func _on_character_hover_changed(character: Character, is_hovered: bool) -> void:
    for crew_button in crew_buttons:
        if crew_button.instantiated_character == character:
            crew_button.mimic_hover_changed(is_hovered)

func _on_character_selected(character: Character, end_button_state: bool) -> void:
    for crew_button in crew_buttons:
        if crew_button.instantiated_character == character:
            crew_button.button_pressed = end_button_state
