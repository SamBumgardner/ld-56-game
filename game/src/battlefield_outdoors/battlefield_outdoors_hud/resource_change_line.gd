class_name ResourceChangeLine extends HBoxContainer

const INCREASE_FORMAT = "+%s"
const DECREASE_FORMAT = "%s" # Negative numbers already have - symbol

@export var texture: Texture2D = preload("res://icon.svg")
@export var resource_name: String = "ResourceName"

@onready var resource_icon: TextureRect = $ResourceIcon
@onready var resource_label: Label = $ResourceName
@onready var change_label: Label = $ChangeLabel

func _ready() -> void:
    resource_icon.texture = texture
    resource_label.text = resource_name
    change_label.text = ""

func set_change_amount(change_amount: int) -> void:
    if change_amount > 0:
        change_label.modulate = Color.WHITE
        change_label.text = INCREASE_FORMAT % change_amount
        show()
    elif change_amount < 0:
        change_label.modulate = Color.RED
        change_label.text = DECREASE_FORMAT % change_amount
        show()
    else:
        hide()