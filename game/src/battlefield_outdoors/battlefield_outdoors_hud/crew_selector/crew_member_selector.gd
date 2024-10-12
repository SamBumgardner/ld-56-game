class_name CrewMemberSelector extends PanelContainer

@onready var crew_selector_buttons: Array[Node] = $MC/GC.get_children()

func _ready() -> void:
    refresh()

func refresh() -> void:
    var hired_characters = Database.hired_characters
    for i in crew_selector_buttons.size():
        var character: Character = null
        if i < hired_characters.size():
            character = hired_characters[i]

        crew_selector_buttons[i].set_character(character)
        crew_selector_buttons[i].button.button_pressed = false

func _on_character_selected(selected_character: Character, button_end_state: bool) -> void:
    for crew_selector_button in crew_selector_buttons:
        if button_end_state:
            crew_selector_button.button.button_pressed = crew_selector_button.character == selected_character
        else:
            crew_selector_button.button.button_pressed = false
