class_name BattlefieldOutdoors extends Control

@onready var war_transport: BattlefieldOutdoorsWarTransport = $AnchorOfWarTransport/BattlefieldOutdoorsWarTransport
@onready var battlefield_outdoors_hud: BattlefieldOutdoorsHud = $BattlefieldOutdoorsHud

func _ready() -> void:
    war_transport.insufficient_fuel.connect(battlefield_outdoors_hud._on_insufficient_fuel)

func transition_in() -> void:
    Database.initialize_missing_die_slots()
    battlefield_outdoors_hud.crew_member_selector.refresh()
    battlefield_outdoors_hud.refresh_calculations()
    battlefield_outdoors_hud.character_info_panel.display_character(null)
