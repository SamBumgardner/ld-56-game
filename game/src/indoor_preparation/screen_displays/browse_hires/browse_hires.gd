class_name BrowseHires extends Control

@onready var new_hire_previews: Array[Node] = $VBoxContainer/GridContainer.get_children()

func _ready() -> void:
    set_new_applicants($"/root/Database".hired_characters)

func set_new_applicants(applicants: Array[Character]) -> void:
    for i in range(new_hire_previews.size()):
        if i < applicants.size():
            new_hire_previews[i].set_character_data(applicants[i])
            new_hire_previews[i].show()
        else:
            new_hire_previews[i].hide()
