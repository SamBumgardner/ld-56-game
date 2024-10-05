class_name UpgradeSelector extends Resource

@export var choices: Array[UpgradeChoice]
@export var price: int

func get_upgrade_action(choice_idx: int) -> Callable:
    return choices[choice_idx].apply_changes

func get_choice_data(choice_idx: int) -> UpgradeChoice:
    return choices[choice_idx]

func get_all_choice_data() -> Array[UpgradeChoice]:
    return choices