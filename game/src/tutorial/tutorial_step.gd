class_name TutorialStep extends Resource

@export var dialogue_position: Vector2
@export var title_text: String
@export_multiline var body_text: String
@export var show_continue_button: bool

@export var show_arrow: bool = true
@export var target_position: Vector2
@export var arrow_rotation: float = 0

func execute_step(tutorial_dialogue: TutorialDialogue, tutorial_arrow: TutorialArrow):
    tutorial_dialogue.display_new_tutorial_step(dialogue_position, title_text, body_text,
        show_continue_button)
    
    if show_arrow:
        tutorial_arrow.show()
        tutorial_arrow.change_target(target_position, arrow_rotation)
    else:
        tutorial_arrow.hide()