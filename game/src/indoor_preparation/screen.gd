class_name Screen extends Control

signal left_character_detail_display()
signal left_hire_detail_display()

enum ScreenViews {
    HOME,
    BROWSE_HIRES,
    HIRE_DETAIL,
    CREW_MEMBER_DETAIL,
}

const SCREEN_LOAD_DELAY: float = .1

@onready var home_display: HomeDisplay = $HomeDisplay
@onready var hire_preview_display: BrowseHires = $HirePreviewDisplay
@onready var hire_detail_display: HireDetail = $HireDetail
@onready var character_detail_display: CrewMemberDetail = $CharacterDetail

var current_view: ScreenViews = ScreenViews.HOME
var loading_delay_tween: Tween

func _ready() -> void:
    home_display.view_applicants_button_pressed.connect(_transition_to_hire_preview_display)
    hire_preview_display.applicant_selected.connect(_applicant_selected_from_hiring_preview)
    hire_preview_display.cancel_button.pressed.connect(_on_cancel)
    hire_detail_display.exit_button.pressed.connect(_on_cancel)
    left_hire_detail_display.connect(hire_detail_display.exited_display)
    left_character_detail_display.connect(character_detail_display.exited_display)
    character_detail_display.exit_button.pressed.connect(_on_cancel)

func register_applicants_for_display(applicants: Array[Character]) -> void:
    hire_preview_display.set_new_applicants(applicants)

func _delay_callback(callback: Callable) -> void:
    if loading_delay_tween != null and loading_delay_tween.is_running():
        loading_delay_tween.stop()
    loading_delay_tween = create_tween()
    loading_delay_tween.tween_interval(SCREEN_LOAD_DELAY)
    loading_delay_tween.tween_callback(callback)

func _transition_to_hire_preview_display() -> void:
    _hide_all_screen_displays()
    current_view = ScreenViews.BROWSE_HIRES
    _delay_callback(hire_preview_display.show)

func _applicant_selected_from_hiring_preview(character: Character) -> void:
    _hide_all_screen_displays()
    current_view = ScreenViews.HIRE_DETAIL
    hire_detail_display.set_character_data(character)
    _delay_callback(hire_detail_display.show)

func _on_crew_member_selected(character: Character) -> void:
    _hide_all_screen_displays()
    current_view = ScreenViews.CREW_MEMBER_DETAIL
    character_detail_display.set_character_data(character)
    _delay_callback(character_detail_display.show)

func _on_cancel() -> void:
    _hide_all_screen_displays()
    match current_view:
        ScreenViews.HOME:
            _delay_callback(home_display.show)
        ScreenViews.BROWSE_HIRES:
            current_view = ScreenViews.HOME
            _delay_callback(home_display.show)
        ScreenViews.HIRE_DETAIL:
            current_view = ScreenViews.BROWSE_HIRES
            _delay_callback(hire_preview_display.show)
        ScreenViews.CREW_MEMBER_DETAIL:
            left_character_detail_display.emit()
            current_view = ScreenViews.HOME
            _delay_callback(home_display.show)

func _hide_all_screen_displays() -> void:
    home_display.hide()
    hire_preview_display.hide()
    hire_detail_display.hide()
    character_detail_display.hide()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        _on_cancel()
        get_viewport().set_input_as_handled()
