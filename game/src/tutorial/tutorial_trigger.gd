class_name TutorialTrigger extends RefCounted

var signal_name: String
var trigger_callback: Callable

func _init(_trigger_name: String, _trigger_callback: Callable) -> void:
    signal_name = _trigger_name
    trigger_callback = _trigger_callback
