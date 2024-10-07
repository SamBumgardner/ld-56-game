class_name BarrierData extends RefCounted

var name: String
var weakness_type: Database.StatType
var cost_to_overcome: int
var graphic: Texture2D

func _init(_name: String, _weakness_type: Database.StatType,
        _cost_to_overcome: int, _graphic: Texture2D) -> void:
    name = _name
    weakness_type = _weakness_type
    cost_to_overcome = _cost_to_overcome
    graphic = _graphic
