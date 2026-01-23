class_name BrowseHires extends Control

signal applicant_selected(character: Character)

@onready var new_hire_previews: Array[Node] = $VBoxContainer/GridContainer.get_children()
@onready var cancel_button: Button = $CancelButton

func _ready() -> void:
    for preview in new_hire_previews:
        preview.pressed.connect(_on_hire_preview_pressed)

func try_grab_focus_on_first_new_hire() -> void:
    if new_hire_previews.size() > 0:
        new_hire_previews[0].get_button().grab_focus()

func set_new_applicants(applicants: Array[Character]) -> void:
    for i in range(new_hire_previews.size()):
        if i < applicants.size():
            new_hire_previews[i].set_character_data(applicants[i])
            new_hire_previews[i].show()
        else:
            new_hire_previews[i].hide()

func _on_hire_preview_pressed(character: Character) -> void:
    applicant_selected.emit(character)
