class_name BattlefieldOutdoors extends Control

@onready var war_transport: BattlefieldOutdoorsWarTransport

func transition_in() -> void:
    war_transport.grid_of_dice_results.initialize_character_die_slots(Database.hired_characters)
