class_name PostgameStatLine extends HBoxContainer

@export var stat_display_name: String
@export var database_field_name: String

@onready var stat_name_label: Label = $StatName
@onready var stat_value_label: Label = $StatValue

func _ready() -> void:
    stat_name_label.text = stat_display_name
    var value = Database.get(database_field_name)
    if value is float:
        stat_value_label.text = "%d" % value
    else:
        stat_value_label.text = "%s" % value
        
