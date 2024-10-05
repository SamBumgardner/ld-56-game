# Represent a character's die roll, and if the current roll is frozen to prevent
#  rerolls.
class_name CharacterDieSlot extends Resource

var character: Character = null
var is_frozen: bool = false
var last_roll_result: Action = null

func _init(_character: Character) -> void:
    character = _character
