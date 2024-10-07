class_name IndoorPreparation extends Control

signal hiring_success(character: Character)
signal hiring_failure(character: Character, reason: String)
signal upgrade_success(character: Character)
signal upgrade_failure(character: Character, reason: String)

const APPLICANT_COUNT: int = 4
const PURCHASE_FAIL_POOR_REASON: String = "INSUFFICIENT_FUNDS"

@onready var database: Database = $"/root/Database"
@onready var screen: Screen = $Screen
@onready var crew_buttons: Array[Node] = $CrewButtons.get_children()

var applicants: Array[Character] = []

func _ready() -> void:
    for crew_button in crew_buttons:
        crew_button.crew_member_selected.connect(screen._on_crew_member_selected)
        screen.left_character_detail_display.connect(crew_button._on_view_canceled)
        hiring_success.connect(crew_button._on_new_character_hired)
    screen.hire_detail_display.hire_purchase_pressed.connect(_on_hire_purchase_attempted)
    screen.character_detail_display.upgrade_purchase_pressed.connect(_on_upgrade_purchase_attempted)
    hiring_success.connect(screen._on_hiring_success)
    hiring_failure.connect(screen._on_hiring_failure)
    upgrade_success.connect(screen._on_upgrade_success)
    upgrade_failure.connect(screen._on_upgrade_failure)
    
    transition_in()

func transition_in() -> void:
    if database.should_generate_new_applicants:
        applicants = database.get_random_unhired(APPLICANT_COUNT)
        database.set_current_applicants(applicants)
        database.should_generate_new_applicants = false
    else:
        applicants = database.applicants
    
    screen.register_applicants_for_display(applicants)

func _on_hire_purchase_attempted(character: Character) -> void:
    # check money is sufficent
    if database.current_money >= character.hiring_cost:
        database.set_money(database.current_money - character.hiring_cost)
        database.hire_character(character)
        applicants = database.applicants
        # TODO: can remove this re-registration and instead let screen handle hiring_success event
        screen.register_applicants_for_display(applicants)
        hiring_success.emit(character)
    else:
        hiring_failure.emit(character, PURCHASE_FAIL_POOR_REASON)

func _on_upgrade_purchase_attempted(character: Character, upgrade_choice: UpgradeChoice,
        upgrade_level: int, choice_idx: int):
    if database.current_money >= upgrade_choice.cost:
        database.set_money(database.current_money - upgrade_choice.cost)
        character.upgrade(upgrade_level, choice_idx)
        screen.refresh_upgrade_display()
        upgrade_success.emit(character)
    else:
        upgrade_failure.emit(character, PURCHASE_FAIL_POOR_REASON)
