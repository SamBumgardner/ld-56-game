class_name RerollButton extends Button

signal hovered_available_reroll
signal exited_available_reroll

@export var reroll_cooldown: float = 1.5

func _ready() -> void:
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)
    pressed.connect(_on_pressed)

func _set_disabled(new_value: bool):
    disabled = new_value
    _on_disabled_changed()

func _on_mouse_entered():
    if not disabled:
        hovered_available_reroll.emit()

func _on_mouse_exited():
    if not disabled:
        exited_available_reroll.emit()

func _on_disabled_changed():
    if disabled and is_hovered():
        exited_available_reroll.emit()
    elif not disabled and is_hovered():
        hovered_available_reroll.emit()

func _on_pressed():
    _set_disabled(true)
    var cooldown_tween = create_tween()
    cooldown_tween.tween_callback(_on_cooldown_complete).set_delay(reroll_cooldown)

func _on_cooldown_complete():
    _set_disabled(false)
    if is_hovered():
        mouse_entered.emit()
