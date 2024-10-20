class_name TutorialSequence extends Resource

@export var steps: Array[TutorialStep]
@export var step_triggers: Array[String]

func get_step_completion_trigger(current_step_idx: int) -> String:
    return step_triggers[current_step_idx]

## Returns null if there is no next step
func get_step_after_trigger(trigger: String, current_step_idx: int = 0) -> TutorialStep:
    var result: TutorialStep = null

    var next_step_idx: int = step_triggers.find(trigger, current_step_idx) + 1
    if next_step_idx == 0:
        # trigger not found, return null
        return null

    if next_step_idx < steps.size():
        result = steps[next_step_idx]
 
    return result
