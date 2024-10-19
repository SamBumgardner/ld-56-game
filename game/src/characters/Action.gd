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
    var action_params: PackedStringArray = action_string.split("_")
    return Action.new(action_string, Database.string_to_stat_type[action_params[0]],
        action_params[1].to_int())

static func generate_action_name(stat: Database.StatType, amount: int) -> String:
    var stat_name: String = Database.stat_type_to_string[stat]
    return "%s_%s" % [stat_name, amount]
