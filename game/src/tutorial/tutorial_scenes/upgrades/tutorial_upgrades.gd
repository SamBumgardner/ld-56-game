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
    type_to_trigger_map["CrewMemberDetail"] = [
        TutorialTrigger.new("visibility_changed", _on_trigger_received.bind("character_detail_open_close")),
    ]
    type_to_trigger_map["UpgradeChoiceDisplay"] = [
        TutorialTrigger.new("upgrade_selected", func(_a, _b, _c): _on_trigger_received("upgrade_selected")),
    ]
    type_to_trigger_map["UpgradeCostPrompt"] = [
        TutorialTrigger.new("upgrade_purchase_pressed", func(_a): _on_trigger_received("upgrade_purchased")),
    ]
    super()
    show()
