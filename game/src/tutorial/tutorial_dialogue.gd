class_name TutorialDialogue extends PanelContainer

@onready var header: Label = $MarginContainer/VBoxContainer/HeaderContainer/PanelContainer/MarginContainer/Header
@onready var body: RichTextLabel = $MarginContainer/VBoxContainer/BodyContainer/PanelContainer/MarginContainer/Body
@onready var body_container: Container = $MarginContainer/VBoxContainer/BodyContainer
@onready var minimize_button: Button = $MarginContainer/VBoxContainer/HeaderContainer/MinimizeButton
@onready var continue_button: Button = $MarginContainer/VBoxContainer/BodyContainer/ContinueButton

func _ready():
    minimize_button.pressed.connect(_toggle_body)

func display_new_tutorial_step(new_global_position: Vector2, header_text: String, body_text: String):
    _jump_to_location(new_global_position)
    _update_texts(header_text, body_text)

func _jump_to_location(new_global_position: Vector2):
    global_position = new_global_position

func _update_texts(new_header_text: String, new_body_text: String):
    header.text = new_header_text
    body.text = new_body_text

func _toggle_body():
    body_container.visible = not body_container.visible
