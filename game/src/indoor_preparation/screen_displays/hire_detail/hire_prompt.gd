class_name HirePrompt extends Node

@onready var cost_display: RichTextLabel = $MarginContainer/VBoxContainer/CostDisplay
@onready var purchase_button: Button = $MarginContainer/VBoxContainer/PurchaseButton

var cost_format_string: String = """[center]Hiring Cost:
[img=15%%]res://assets/art/ATTACK_icon_64x64.png[/img]%s"""


func set_character_data(character: Character) -> void:
    cost_display.text = cost_format_string % character.hiring_cost
