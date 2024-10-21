extends GameOver

var stats_displayed: bool = true

func _start_fade_in_sequence() -> Tween:
    var fade_in_sequence: Tween = super()
    _append_fade_in_steps($ToggleBackgroundButton, fade_in_sequence)

    return fade_in_sequence

func _on_show_background_button_pressed() -> void:
    # toggle display of stats and faded rect
    
    stats_displayed = not stats_displayed
    title_container.visible = stats_displayed
    stats_container.visible = stats_displayed
    button_container.visible = stats_displayed

    self_modulate = Color(.4, .4, .4) if stats_displayed else Color.WHITE
    var background_button: Button = $ToggleBackgroundButton
    background_button.modulate = Color(1, 1, 1, .25)

    background_button.text = "Show Background" if stats_displayed else "Show Stats"
