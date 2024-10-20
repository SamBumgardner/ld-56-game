extends Tutorial

func _ready() -> void:
    type_to_trigger_map["BattlefieldOutdoors"] = [
        TutorialTrigger.new("charge_start", _on_trigger_received.bind("charge_started")),
        TutorialTrigger.new("charge_finish", _on_trigger_received.bind("charge_finished"))
    ]
    super()
    show()
