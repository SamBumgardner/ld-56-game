extends PanelContainer

@export var action: Action = null

@onready var amount: Label = $MarginContainer/HBoxContainer/Amount
@onready var symbol: TextureRect = $MarginContainer/HBoxContainer/Symbol

func _ready():
    set_action(action)


func set_action(action: Action) -> void:
    if action == null:
        visible = false
        return

    amount.text = str(action.amount)
    symbol.texture = Database.stat_type_to_icon[action.stat_type]
    visible = true