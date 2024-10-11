class_name BattlefieldOutdoors extends Control

@onready var war_transport: BattlefieldOutdoorsWarTransport = $AnchorOfWarTransport/BattlefieldOutdoorsWarTransport
@onready var fuel_display: FuelDisplay = $VBoxContainer/FuelDisplay
@onready var battlefield_outdoors_hud: BattlefieldOutdoorsHud = $BattlefieldOutdoorsHud

func _ready() -> void:
    war_transport.insufficient_fuel.connect(fuel_display._on_insufficient_resource)
    war_transport.insufficient_fuel.connect(battlefield_outdoors_hud._on_insufficient_fuel)

func transition_in() -> void:
    war_transport.grid_of_dice_results.initialize_character_die_slots(Database.hired_characters)
