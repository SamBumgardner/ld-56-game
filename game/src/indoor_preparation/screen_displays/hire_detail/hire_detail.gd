class_name HireDetail extends CharacterDetail

signal hire_purchase_pressed(character: Character)

@onready var hire_cost_prompt: HirePrompt = $IconAndCost/HirePrompt

func _ready() -> void:
    super()
    hire_cost_prompt.purchase_button.pressed.connect(_on_hire_button_pressed)

func set_character_data(new_character: Character):
    super(new_character)
    hire_cost_prompt.set_character_data(new_character)

func _on_hire_button_pressed():
    upgrade_selection.unpress_all_upgrade_buttons()
    dynamic_info_panel.clear_upgrade_data()
    hire_purchase_pressed.emit(character)
