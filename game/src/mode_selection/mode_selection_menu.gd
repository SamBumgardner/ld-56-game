class_name ModeSelectionMenu extends Control

const START_RESOURCE_FORMATS: Array[String] = [
    "Health: %s",
    "[img=33%%]res://assets/art/tiny_silver_coin.png[/img] %s",
    "[img=33%%]res://assets/art/energy_icon.png[/img] %s",
]

@export var scenarios: Array[Scenario] = []

@onready var scenario_buttons: Array[Node] = $ScenarioOptions/ScenarioButtons.get_children()
@onready var start_button: Button = $ScenarioInfoDisplay/VBoxContainer/StartContainer/StartButton

@onready var content_container: Control = $ScenarioInfoDisplay/VBoxContainer

@onready var title_header: Label = $ScenarioInfoDisplay/VBoxContainer/TitlePanel/MarginContainer/Label
@onready var description_body: Label = $ScenarioInfoDisplay/VBoxContainer/ContentsContainer/VBoxContainer/DescriptionContainer/PanelContainer/MarginContainer/VBoxContainer/Body
const difficulty_format: String = "Difficulty: %s/5"
@onready var difficulty_label: Label = $ScenarioInfoDisplay/VBoxContainer/ContentsContainer/VBoxContainer/DescriptionContainer/PanelContainer/MarginContainer/VBoxContainer/DifficultyRating

@onready var starting_health_label: RichTextLabel = $ScenarioInfoDisplay/VBoxContainer/ContentsContainer/VBoxContainer/StartingResourcesContainer/PanelContainer/MarginContainer/ResourceLabels/StartingHealth
@onready var starting_coin_label: RichTextLabel = $ScenarioInfoDisplay/VBoxContainer/ContentsContainer/VBoxContainer/StartingResourcesContainer/PanelContainer/MarginContainer/ResourceLabels/StartingCoin
@onready var starting_fuel_label: RichTextLabel = $ScenarioInfoDisplay/VBoxContainer/ContentsContainer/VBoxContainer/StartingResourcesContainer/PanelContainer/MarginContainer/ResourceLabels/StartingEnergy

const crew_random_format: String = "Get %s random crew from this pool:"
@onready var crew_random_label: Label = $ScenarioInfoDisplay/VBoxContainer/ContentsContainer/VBoxContainer/StartingCrewContainer/PortraitContainer/MarginContainer/VBoxContainer/RandomCount
@onready var crew_portraits1: Array = $ScenarioInfoDisplay/VBoxContainer/ContentsContainer/VBoxContainer/StartingCrewContainer/PortraitContainer/MarginContainer/VBoxContainer/CrewPortraits1.get_children()
@onready var crew_portraits2: Array = $ScenarioInfoDisplay/VBoxContainer/ContentsContainer/VBoxContainer/StartingCrewContainer/PortraitContainer/MarginContainer/VBoxContainer/CrewPortraits2.get_children()
var combined_portraits: Array

@onready var total_distance_label: Label = $ScenarioInfoDisplay/VBoxContainer/ContentsContainer/VBoxContainer/GoalContainer/PanelContainer/MarginContainer/Body

func _ready():
    combined_portraits = []
    combined_portraits.append_array(crew_portraits1)
    combined_portraits.append_array(crew_portraits2)

    for i in scenario_buttons.size():
        if scenarios.size() > i:
            scenario_buttons[i].text = scenarios[i].scenario_name
            scenario_buttons[i].pressed.connect(display_scenario_information.bind(scenarios[i]))
        else:
            scenario_buttons[i].hide()


func display_scenario_information(scenario: Scenario):
    content_container.show()

    title_header.text = scenario.scenario_name
    description_body.text = scenario.scenario_description
    difficulty_label.text = difficulty_format % scenario.difficulty_rating
    starting_health_label.text = START_RESOURCE_FORMATS[0] % scenario.gameplay_init_values.war_transport_health_maximum
    starting_coin_label.text = START_RESOURCE_FORMATS[1] % scenario.gameplay_init_values.current_money
    starting_fuel_label.text = START_RESOURCE_FORMATS[2] % scenario.gameplay_init_values.current_fuel


    var starting_characters: Array[CharacterFactory] = []
    for i in scenario.possible_start_char_options:
        starting_characters.append(scenario.available_characters[i])

    if scenario.start_char_count < starting_characters.size():
        crew_random_label.text = crew_random_format % scenario.start_char_count
        crew_random_label.show()
    else:
        crew_random_label.hide()

    for i in combined_portraits.size():
        if i < starting_characters.size():
            combined_portraits[i].texture = starting_characters[i].portrait
        else:
            combined_portraits[i].hide()
    
    total_distance_label.text = "%s km" % scenario.total_distance
