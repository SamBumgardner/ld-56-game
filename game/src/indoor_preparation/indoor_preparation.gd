class_name IndoorPreparation extends Control

signal hiring_success(character: Character)
signal hiring_failure(character: Character, reason: String)
signal upgrade_success(character: Character)
signal upgrade_failure(character: Character, reason: String)
signal insufficient_funds()

const PURCHASE_FAIL_POOR_REASON: String = "INSUFFICIENT_FUNDS"

@onready var database: Database = $"/root/Database"
@onready var screen: Screen = $Screen
@onready var crew_buttons: Array[Node] = $CrewButtons.get_children()
@onready var money_display: MoneyDisplay = $VBoxContainer/MoneyDisplay

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
    insufficient_funds.connect(money_display._on_insufficient_resource)
    
    if get_tree().current_scene == self:
        transition_in()

func transition_in() -> void:
    process_mode = PROCESS_MODE_INHERIT
    applicants = database.applicants
    
    screen.register_applicants_for_display(applicants)
    screen.return_to_home_display()
    screen.home_display.set_barrier(database.current_barrier_data)
    money_display.force_display_resolution()

    for button: Button in (crew_buttons as Array[Button]):
        button.button_pressed = false

func transition_out() -> void:
    process_mode = PROCESS_MODE_DISABLED

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
        insufficient_funds.emit()

func _on_upgrade_purchase_attempted(character: Character, upgrade_choice: UpgradeChoice,
        upgrade_level: int, choice_idx: int):
    if database.current_money >= upgrade_choice.cost:
        database.set_money(database.current_money - upgrade_choice.cost)
        character.upgrade(upgrade_level, choice_idx)
        upgrade_success.emit(character)
    else:
        upgrade_failure.emit(character, PURCHASE_FAIL_POOR_REASON)
        insufficient_funds.emit()

func _on_checkpoint_saved() -> void:
    screen.on_checkpoint_saved()

func _on_new_applicants_arrived() -> void:
    screen.on_new_applicants_arrived()
