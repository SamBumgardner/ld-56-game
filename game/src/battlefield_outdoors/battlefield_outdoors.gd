class_name BattlefieldOutdoors extends Control

@onready var war_transport: BattlefieldOutdoorsWarTransport = $AnchorOfWarTransport/BattlefieldOutdoorsWarTransport
@onready var fuel_display: FuelDisplay = $VBoxContainer/FuelDisplay

func _ready() -> void:
    war_transport.insufficient_fuel.connect(fuel_display._on_insufficient_resource)

func transition_in() -> void:
    war_transport.grid_of_dice_results.initialize_character_die_slots(Database.hired_characters)
