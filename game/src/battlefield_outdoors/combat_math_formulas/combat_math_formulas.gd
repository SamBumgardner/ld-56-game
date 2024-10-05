# Class to define methods for combat math formulas.
class_name CombatMathFormulas

const default_damage_amount = 0


# Sum dice results, ignoring `StatType` of dice and barrier.
func sum_dice_amounts(
    character_die_slots: Array[CharacterDieSlot]
) -> int:
    # Type `Array[Action]`.
    var character_die_results = (
        character_die_slots.map(
            func (character_die_slot: CharacterDieSlot) -> Action: return (
                character_die_slot.last_roll_result
            )
        )
    )

    # Type `Array[int]`.
    var character_die_results_amount_list = (
        character_die_results
            .filter(
                func (character_die_result: Action) -> bool: return (
                    character_die_result != null
                )
            )
            .map(
                func (character_die_result: Action) -> int: \
                    return character_die_result.amount
            )
    )

    return character_die_results_amount_list.reduce(
        func (accumulator: int, amount: int) -> int: return (
            accumulator
            + amount
        ),
        default_damage_amount
    )
