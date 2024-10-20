extends Tutorial

func _ready() -> void:
    type_to_trigger_map["BattlefieldOutdoors"] = [
        TutorialTrigger.new("dice_roll_started", _on_trigger_received.bind("reroll_succeeded")),
    ]
    super()
    show()
