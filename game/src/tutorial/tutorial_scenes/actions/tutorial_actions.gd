extends Tutorial

func _ready() -> void:
    type_to_trigger_map["CharacterInfoPanel"] = [
        TutorialTrigger.new("visibility_changed", _on_trigger_received.bind("character_info_panel_opened")),
    ]
    super()
    show()
