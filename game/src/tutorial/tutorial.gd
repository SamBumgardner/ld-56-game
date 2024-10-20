class_name Tutorial extends Node

const TRIGGER_NODE_GROUP: String = "tutorial_triggers"

@export var tutorial_sequence: TutorialSequence

@onready var tutorial_dialogue: TutorialDialogue = $TutorialDialogue
@onready var tutorial_arrow: TutorialArrow = $TutorialArrow

var current_step_idx = 0

## Child classes populate with type-to-callables
var type_to_trigger_map: Dictionary = {
    "TutorialDialogue": TutorialTrigger.new("continue_button_pressed", func(): _on_trigger_received("tutorial_continue"))
}

func _ready():
    # get all possible trigger nodes
    var trigger_emitters: Array = get_tree().get_nodes_in_group(TRIGGER_NODE_GROUP)
    # call 
    _connect_trigger_events(trigger_emitters)
    tutorial_sequence.steps[0].execute_step(tutorial_dialogue, tutorial_arrow, true)

func _connect_trigger_events(trigger_emitters: Array) -> void:
    for emitter in trigger_emitters:
        # Get emitter type name
        var emitter_type_name: String
        if emitter.get_script() != null:
            emitter_type_name = emitter.get_script().get_global_name()
        else:
            emitter_type_name = emitter.get_class()
    
        # Check if emitter type matters to this tutorial...
        if emitter_type_name in type_to_trigger_map.keys():
            # It does - grab info about the trigger we should wire up, then make the connection
            var trigger_info: TutorialTrigger = type_to_trigger_map[emitter_type_name]
            emitter.connect(trigger_info.signal_name, trigger_info.trigger_callback)

func _on_trigger_received(trigger_name: String):
    # Check if the received trigger completes the current step: 
    if tutorial_sequence.get_step_completion_trigger(current_step_idx) == trigger_name:
        var next_step: TutorialStep = \
            tutorial_sequence.get_step_after_trigger(trigger_name, current_step_idx)

        # If there's another step, execute it
        if next_step != null:
            current_step_idx += 1
            next_step.execute_step(tutorial_dialogue, tutorial_arrow)
        else:
            # tutorial is finished, go back to main menu
            get_tree().change_scene_to_file("res://src/start_menu/StartMenu.tscn")
