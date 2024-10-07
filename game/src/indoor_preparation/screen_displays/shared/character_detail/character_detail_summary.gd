class_name CharacterDetailSummary extends Control

@onready var portrait: TextureRect = $Portrait
@onready var name_label: Label = $VBoxContainer/Name
@onready var description_label: Label = $VBoxContainer/Description
@onready var action_previews: Array[Node] = $VBoxContainer/ActionsPreview.get_children()

func set_character_data(character: Character) -> void:
    portrait.texture = character.portrait
    name_label.text = character.name
    description_label.text = character.description
    _set_action_previews(character.actions.get_all())
    
func _set_action_previews(actions: Array[Action]) -> void:
    for i in range(action_previews.size()):
        if i < actions.size():
            action_previews[i].set_action(actions[i])
        else:
            action_previews[i].set_action(null)
