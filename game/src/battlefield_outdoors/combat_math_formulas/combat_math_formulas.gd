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


# Sum and multiply only dice results that match the target StatType.
func total_dice_only_matching_stat_type_multiplier(
    character_die_slots: Array[CharacterDieSlot],
    target_stat_type: Database.StatType,
    matching_stat_type_multiplier: int
) -> int:
    # Type `Array[Action]`.
    var populated_character_die_results = _get_populated_die_rolls(
        character_die_slots
    )

    # Type `Array[Action]`.
    var matching_character_die_results = populated_character_die_results.filter(
        _handle_is_action_matching_stat_type(target_stat_type)
    )

    # Type `Array[int]`.
    var multiplied_character_die_results_list = matching_character_die_results.map(
        _handle_get_action_amount_with_matching_stat_type_multiplier(
            target_stat_type,
            matching_stat_type_multiplier
        )
    )

    return multiplied_character_die_results_list.reduce(
        _sum_integers,
        default_damage_amount
    )


# Sum dice results, multiplying dice that match the target StatType.
func total_dice_with_matching_stat_type_multiplier(
    character_die_slots: Array[CharacterDieSlot],
    target_stat_type: Database.StatType,
    matching_stat_type_multiplier: int
) -> int:
    # Type `Array[Action]`.
    var populated_character_die_results = _get_populated_die_rolls(
        character_die_slots
    )

    # Type `Array[int]`.
    var multiplied_character_die_results_list = populated_character_die_results.map(
        _handle_get_action_amount_with_matching_stat_type_multiplier(
            target_stat_type,
            matching_stat_type_multiplier
        )
    )

    return multiplied_character_die_results_list.reduce(
        _sum_integers,
        default_damage_amount
    )


#region Private methods

func _get_action_amount(action: Action) -> int:
    return action.amount


func _handle_get_action_amount_with_matching_stat_type_multiplier(
    target_stat_type: Database.StatType,
    matching_stat_type_multiplier: int
):
    return func(action: Action) -> int: return (
        action.amount * matching_stat_type_multiplier
            if action.stat_type == matching_stat_type_multiplier
            else action.amount
    )


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


func _handle_is_action_matching_stat_type(target_stat_type: Database.StatType):
    return func(action: Action) -> bool: return (
        action.stat_type == target_stat_type
    )


func _is_action_populated(action: Action) -> bool:
    return action != null


func _sum_integers(accumulator: int, amount: int) -> int:
    return accumulator + amount

#endregion Private methods
