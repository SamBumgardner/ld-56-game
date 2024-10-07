class_name HomeDisplay extends Control

signal view_applicants_button_pressed()

@onready var barrier_name: Label = $MainContents/BarrierName
@onready var barrier_portrait: TextureRect = $MainContents/BarrierDetails/Image
@onready var weakness_icon: TextureRect = $MainContents/BarrierDetails/StatsContainer/WeaknessContainer/MarginContainer/HBoxContainer/WeaknessIcon
@onready var power_value: Label = $MainContents/BarrierDetails/StatsContainer/PowerContainer/MarginContainer/HBoxContainer2/PowerValue
@onready var flavor_text: Label = $MainContents/MarginContainer/FlavorText
@onready var view_applicants_button: Button = $MarginContainer/Button

func _ready() -> void:
    view_applicants_button.pressed.connect(_propagate_applicants_button_pressed)

func set_barrier(barrier_data: BarrierData):
    barrier_name.text = barrier_data.name
    barrier_portrait.texture = barrier_data.graphic
    weakness_icon.texture = Database.stat_type_to_icon[barrier_data.weakness_type]
    power_value.text = String.num_int64(barrier_data.cost_to_overcome)

func _propagate_applicants_button_pressed():
    view_applicants_button_pressed.emit()
