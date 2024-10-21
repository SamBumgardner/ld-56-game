class_name NewHirePreview extends MarginContainer

signal pressed(character: Character)

const cost_format_string: String = "[center]Cost:\n[img=25%%]res://assets/art/ATTACK_icon_64x64.png[/img] %s"

@onready var button: Button = $Button
@onready var portrait: TextureRect = $MarginContainer/VBoxContainer/NewHirePreview/Portrait
@onready var name_label: Label = $MarginContainer/VBoxContainer/NewHirePreview/VBoxContainer/Name
@onready var description: Label = $MarginContainer/VBoxContainer/NewHirePreview/VBoxContainer/Description
@onready var cost_label: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/Cost
@onready var action_previews_1: Array[Node] = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ActionsPreview.get_children()
@onready var action_previews_2: Array[Node] = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ActionsPreview2.get_children()

var action_previews: Array[Node]
var displayed_character: Character

func _ready() -> void:
    action_previews = []
    action_previews.append_array(action_previews_1)
    action_previews.append_array(action_previews_2)
    button.pressed.connect(_on_button_pressed)

func set_character_data(character: Character) -> void:
    portrait.texture = character.icon
    name_label.text = character.name
    description.text = character.job_name
    cost_label.text = cost_format_string % character.hiring_cost
    _set_action_previews(character.actions.get_all())
    displayed_character = character
    
func _set_action_previews(actions: Array[Action]) -> void:
    for i in range(action_previews.size()):
        if i < actions.size():
            action_previews[i].set_action(actions[i])
        else:
            action_previews[i].set_action(null)

func _on_button_pressed() -> void:
    pressed.emit(displayed_character)
