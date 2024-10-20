extends Tutorial

func _ready() -> void:
    type_to_trigger_map["BattlefieldOutdoors"] = [
        TutorialTrigger.new("charge_start", _on_trigger_received.bind("charge_started")),
        TutorialTrigger.new("charge_finish", _on_trigger_received.bind("charge_finished")),
    ]
    type_to_trigger_map["GoInsideButton"] = [
        TutorialTrigger.new("pressed", _on_trigger_received.bind("go_inside")),
    ]
    type_to_trigger_map["GoOutsideButton"] = [
        TutorialTrigger.new("pressed", _on_trigger_received.bind("go_outside")),
    ]
    super()
    show()
