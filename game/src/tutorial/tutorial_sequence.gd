class_name TutorialSequence extends Resource

@export var steps: Array[TutorialStep]
@export var step_triggers: Array[String]

func get_step_completion_trigger(current_step_idx: int) -> String:
    return step_triggers[current_step_idx]

## Returns null if there is no next step
func get_step_after_trigger(trigger: String) -> TutorialStep:
    var result: TutorialStep = null

    var step_idx: int = step_triggers.find(trigger) + 1
    if (step_idx == 0):
        push_warning("looked up non-existent trigger. Tutorial flow is probably broken")
    
    if step_idx < steps.size():
        result = steps[step_idx]
 
    return result
