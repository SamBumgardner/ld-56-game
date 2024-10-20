class_name TutorialDialogue extends Control

signal continue_button_pressed()

@onready var header: Label = $PanelContainer/MarginContainer/VBoxContainer/HeaderContainer/PanelContainer/MarginContainer/Header
@onready var body: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/BodyContainer/PanelContainer/MarginContainer/VBoxContainer/Body
@onready var body_container: Container = $PanelContainer/MarginContainer/VBoxContainer/BodyContainer
@onready var minimize_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HeaderContainer/MinimizeButton
@onready var continue_divider: Control = $PanelContainer/MarginContainer/VBoxContainer/BodyContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueDivider
@onready var continue_button: Button = $PanelContainer/MarginContainer/VBoxContainer/BodyContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton

func _ready():
    minimize_button.pressed.connect(_toggle_body)
    continue_button.pressed.connect(continue_button_pressed.emit)

func display_new_tutorial_step(new_position: Vector2, header_text: String, body_text: String,
        show_continue_button: bool):
    _jump_to_location(new_position)
    _update_texts(header_text, body_text)
    continue_divider.visible = show_continue_button
    continue_button.visible = show_continue_button

func _jump_to_location(new_position: Vector2):
    position = new_position
    size.y = 0

func _update_texts(new_header_text: String, new_body_text: String):
    header.text = new_header_text
    body.text = new_body_text

func _toggle_body():
    body_container.visible = not body_container.visible
