class_name Action extends Resource

var name: String
var stat_type: Database.StatType
var amount: int

func _init(_name: String, _stat_type: Database.StatType,
        _amount: int) -> void:
    name = _name
    stat_type = _stat_type
    amount = _amount

static func _parse_action_string(action_string: String) -> Action:
    var action_params: Array[String] = action_string.split("_")
    return Action.new(action_string, Database.string_to_stat_type[action_params[0]],
        action_params[1].to_int())
