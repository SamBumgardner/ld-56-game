class_name BarrierData extends RefCounted

const possible_graphics: Array[Texture2D] = [
    preload("res://assets/art/barriers/Wall_01.png"),
    preload("res://assets/art/barriers/Wall_02.png"),
    preload("res://assets/art/barriers/Wall_03.png"),
    preload("res://assets/art/barriers/Wall_04.png"),
]
const random_display_name_adjective_list = [
    'Looming',
    'Menacing',
    'Nice',
    'Worn'
]
const random_display_name_root_list = [
    'Boulder',
    'Pyramid',
    'Security Gate'
]

var name: String
var weakness_type: Database.StatType
var cost_to_overcome: float
var graphic: Texture2D

func _init(_name: String, _weakness_type: Database.StatType,
        _cost_to_overcome: float, _graphic: Texture2D = null) -> void:
    name = _name
    weakness_type = _weakness_type
    cost_to_overcome = _cost_to_overcome
    
    if _graphic == null:
        _graphic = possible_graphics.pick_random()
    graphic = _graphic

static func _get_random_display_name() -> String:
    return (
        random_display_name_adjective_list.pick_random()
        + ' '
        + random_display_name_root_list.pick_random()
    )
