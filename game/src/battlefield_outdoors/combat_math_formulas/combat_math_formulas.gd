# Class to define methods for combat math formulas.
class_name CombatMathFormulas

const default_damage_amount = 0


# Sum dice results, ignoring `StatType` of dice and barrier.
func sum_dice_amounts(
    character_die_slots: Array[CharacterDieSlot]
) -> int:
    # Type `Array[Action]`.
    var populated_character_die_results = _get_populated_die_rolls(
        character_die_slots
    )

    # Type `Array[int]`.
    var character_die_results_amount_list = populated_character_die_results.map(
        _get_action_amount
    )

    return character_die_results_amount_list.reduce(
        _sum_integers,
        default_damage_amount
    )


#region Private methods

func _get_action_amount(action: Action) -> int:
    return action.amount


func _get_character_die_slot_last_roll_result(
    character_die_slot: CharacterDieSlot
) -> Action:
    return character_die_slot.last_roll_result


# Type `Array[CharacterDieSlot] -> Array[Action]`.
func _get_populated_die_rolls(
    character_die_slots: Array[CharacterDieSlot]
) -> Array:
    var character_die_results = character_die_slots.map(
        _get_character_die_slot_last_roll_result
    )

    return character_die_results.filter(_is_action_populated)


func _is_action_populated(action: Action) -> bool:
    return action != null


func _sum_integers(accumulator: int, amount: int) -> int:
    return accumulator + amount

#endregion Private methods
