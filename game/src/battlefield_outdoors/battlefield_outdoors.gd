class_name BattlefieldOutdoors extends Control

signal charge_start()
signal charge_warmup(duration: float)
signal charge_action(duration: float)
signal charge_impact(duration: float)
signal charge_cooldown(duration: float)
signal charge_finish()

@onready var war_transport: BattlefieldOutdoorsWarTransport = $AnchorOfWarTransport/BattlefieldOutdoorsWarTransport
@onready var battlefield_outdoors_hud: BattlefieldOutdoorsHud = $BattlefieldOutdoorsHud

var charge_sequence_tween: Tween

func _ready() -> void:
    war_transport.insufficient_fuel.connect(battlefield_outdoors_hud._on_insufficient_fuel)
    battlefield_outdoors_hud.initiate_charge_requested.connect(_begin_charge_sequence)

    _connect_hud_charge_events()

func _connect_hud_charge_events() -> void:
    charge_start.connect(battlefield_outdoors_hud._on_charge_start)
    charge_warmup.connect(battlefield_outdoors_hud._on_charge_warmup)
    charge_action.connect(battlefield_outdoors_hud._on_charge_action)
    charge_impact.connect(battlefield_outdoors_hud._on_charge_impact)
    charge_cooldown.connect(battlefield_outdoors_hud._on_charge_cooldown)
    charge_finish.connect(battlefield_outdoors_hud._on_charge_finish)

func transition_in() -> void:
    Database.initialize_missing_die_slots()
    battlefield_outdoors_hud.crew_member_selector.refresh()
    battlefield_outdoors_hud.refresh_calculations()
    battlefield_outdoors_hud.character_info_panel.display_character(null)

func _begin_charge_sequence() -> void:
    if charge_sequence_tween != null and charge_sequence_tween.is_running():
        push_error("Attempted to start a charge while one was already in progress.")
        return

    charge_sequence_tween = create_tween()
    charge_sequence_tween.tween_callback(charge_warmup.emit.bind(ChargeSequence.WARMUP_DURATION))
    charge_sequence_tween.tween_interval(ChargeSequence.WARMUP_DURATION)
    charge_sequence_tween.tween_callback(charge_action.emit.bind(ChargeSequence.ACTION_DURATION))
    charge_sequence_tween.tween_interval(ChargeSequence.ACTION_DURATION)
    charge_sequence_tween.tween_callback(charge_impact.emit.bind(ChargeSequence.IMPACT_DURATION))
    charge_sequence_tween.tween_interval(ChargeSequence.IMPACT_DURATION)
    charge_sequence_tween.tween_callback(charge_cooldown.emit.bind(ChargeSequence.COOLDOWN_DURATION))
    charge_sequence_tween.tween_interval(ChargeSequence.COOLDOWN_DURATION)
    charge_sequence_tween.tween_callback(charge_finish.emit)

    charge_start.emit()
