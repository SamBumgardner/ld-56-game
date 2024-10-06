class_name IndoorPreparation extends Control

const APPLICANT_COUNT: int = 4

@onready var database: Database = $"/root/Database"
@onready var screen: Screen = $Screen
@onready var crew_buttons: Array[Node] = $CrewButtons.get_children()

var applicants: Array[Character] = []

func _ready() -> void:
    for crew_button in crew_buttons:
        crew_button.crew_member_selected.connect(screen._on_crew_member_selected)
        screen.left_character_detail_display.connect(crew_button._on_view_canceled)
    
    if database.should_generate_new_applicants:
        # do the steps to generate new hires.
        applicants = database.get_random_unhired(APPLICANT_COUNT)
        database.set_current_applicants(applicants)
        database.should_generate_new_applicants = false
    else:
        applicants = database.applicants
    
    screen.register_applicants_for_display(applicants)
