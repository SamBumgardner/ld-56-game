class_name PostgameStatLine extends HBoxContainer

@export var stat_display_name: String
@export var database_field_name: String

@onready var stat_name_label: Label = $StatName
@onready var stat_value_label: Label = $StatValue

func _ready() -> void:
    stat_name_label.text = stat_display_name
    stat_value_label.text = "%s" % Database.get(database_field_name)
