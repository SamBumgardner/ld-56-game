class_name IndoorPreparation extends Control

@onready var screen: Screen = $Screen
@onready var crew_buttons: Array[Node] = $CrewButtons.get_children()

func _ready() -> void:
    for crew_button in crew_buttons:
        crew_button.crew_member_selected.connect(screen._on_crew_member_selected)
        screen.left_character_detail_display.connect(crew_button._on_view_canceled)
