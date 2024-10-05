extends VBoxContainer

@export var cost_to_overcome_number = 1
@export var display_name = ""

@onready var cost_to_overcome_number_label = $CostToOvercome/Amount
@onready var display_name_label = $BarrierName


func _ready():
    cost_to_overcome_number_label.text = str(cost_to_overcome_number)
    display_name_label.text = display_name
