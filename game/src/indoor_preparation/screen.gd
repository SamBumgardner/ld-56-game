class_name Screen extends Control

enum ScreenViews {
    HOME,
    BROWSE_HIRES,
    HIRE_DETAIL,
    CREW_MEMBER_DETAIL,
}

@onready var home_display: HomeDisplay = $HomeDisplay
@onready var hire_preview_display: BrowseHires = $HirePreviewDisplay
@onready var hire_detail_display: HireDetail = $HireDetail
@onready var character_detail_display: CrewMemberDetail = $CharacterDetail

var current_view: ScreenViews = ScreenViews.HOME

func _ready() -> void:
    home_display.view_applicants_button_pressed.connect(_transition_to_hire_preview_display)
    hire_preview_display.applicant_selected.connect(_applicant_selected_from_hiring_preview)
    hire_preview_display.cancel_button.pressed.connect(_on_cancel)
    hire_detail_display.exit_button.pressed.connect(_on_cancel)
    character_detail_display.exit_button.pressed.connect(_on_cancel)

func _transition_to_hire_preview_display() -> void:
    _hide_all_screen_displays()
    current_view = ScreenViews.BROWSE_HIRES
    hire_preview_display.show()

func _applicant_selected_from_hiring_preview(character: Character) -> void:
    _hide_all_screen_displays()
    current_view = ScreenViews.HIRE_DETAIL
    hire_detail_display.set_character_data(character)
    hire_detail_display.show()

func _on_cancel() -> void:
    _hide_all_screen_displays()
    match current_view:
        ScreenViews.HOME:
            home_display.show()
        ScreenViews.BROWSE_HIRES:
            current_view = ScreenViews.HOME
            home_display.show()
        ScreenViews.HIRE_DETAIL:
            current_view = ScreenViews.BROWSE_HIRES
            hire_preview_display.show()
        ScreenViews.CREW_MEMBER_DETAIL:
            current_view = ScreenViews.HOME
            home_display.show()

func _hide_all_screen_displays() -> void:
    home_display.hide()
    hire_preview_display.hide()
    hire_detail_display.hide()
    character_detail_display.hide()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        _on_cancel()
        get_viewport().set_input_as_handled()
