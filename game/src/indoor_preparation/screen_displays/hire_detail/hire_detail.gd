class_name HireDetail extends CharacterDetail

@onready var hire_cost_prompt: HirePrompt = $IconAndCost/HirePrompt

func set_character_data(character: Character):
    super(character)
    hire_cost_prompt.set_character_data(character)
