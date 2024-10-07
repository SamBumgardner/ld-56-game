# Represent a character's die roll, and if the current roll is frozen to prevent
#  rerolls.
class_name CharacterDieSlot extends Resource

var character: Character = null
var is_frozen: bool = false
var last_roll_result: Action = null


func _init(_character: Character, _is_frozen: bool = false) -> void:
    character = _character
    is_frozen = _is_frozen


func roll_action() -> Action:
    if is_frozen:
        return null

    return character.roll_action()
