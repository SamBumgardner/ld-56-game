class_name ApplicantOrchestrator extends Node

signal new_applicants_arrived()

const NEW_APPLICANTS_MESSAGE: String = "Mercenaries are looking for work.\nCurrent number of applicants: %s"
const NEW_APPLICANTS_DURATION: float = 3.0

var rounds_since_last_applicant: int = 0
var rounds_since_applicant_left: int = 0

func _ready() -> void:
    rounds_since_last_applicant = 10 - min(4, Database.barriers_overcome_count)

    if Database._initial_applicant_count > 0 and Database.applicants.is_empty():
        Database.set_current_applicants(_select_new_applicants(Database._initial_applicant_count))

func update_applicants():
    var current_round: int = Database.barriers_overcome_count
    var current_applicants: Array[Character] = Database.applicants
    var crew_size: int = Database.hired_character_count

    if current_round < Database.first_hiring_round:
        return
    
    rounds_since_applicant_left += 1
    rounds_since_last_applicant += 1

    if rounds_since_last_applicant > 1:
        current_applicants = _applicants_leave(current_round, current_applicants)
    if rounds_since_last_applicant > 4:
        current_applicants = _applicants_arrive(current_applicants, current_round, crew_size)

    Database.set_current_applicants(current_applicants)

    if rounds_since_last_applicant == 0:
        new_applicants_arrived.emit()


func _applicants_leave(current_round: int, applicants: Array[Character]) -> Array[Character]:
    var num_to_remove: int = _calculate_leave_count(current_round)

    # reset rounds since left if applicants is empty or losing someone
    if num_to_remove > 0 or applicants.is_empty():
        rounds_since_applicant_left = 0

    return _pop_back_applicants(applicants, num_to_remove)

func _applicants_arrive(
        applicants: Array[Character],
        current_round: int,
        crew_size: int
        ) -> Array[Character]:
    var num_to_add: int = _calculate_applicant_count(current_round, crew_size)

    if num_to_add > 0:
        var new_applicants: Array[Character] = _select_new_applicants(num_to_add)
        for applicant: Character in new_applicants:
            _adjust_price(applicant, current_round, crew_size)
        
        if not new_applicants.is_empty():
            rounds_since_last_applicant = 0
        if new_applicants.size() + applicants.size() > Database.MAX_APPLICANTS:
            rounds_since_applicant_left = 0
        
        applicants = _cycle_applicants(new_applicants, applicants)

    return applicants


func _calculate_leave_count(current_round: int) -> int:
    const leave_multiplier: float = .1
    const unlucky_round_frequency: int = 5
    const unlucky_round_multiplier: float = 1.5

    var leave_chance = leave_multiplier * rounds_since_applicant_left
    if current_round % unlucky_round_frequency == 0:
        leave_chance *= unlucky_round_multiplier
    
    var leave_count = floor(leave_chance / randf())

    return leave_count

func _pop_back_applicants(
        current_applicants: Array[Character],
        number_to_remove: int
        ) -> Array[Character]:
    
    if number_to_remove > current_applicants.size():
        return []
    else:
        return current_applicants.slice(0, current_applicants.size() - number_to_remove)

func _calculate_applicant_count(current_round: int, crew_size: int) -> int:
    const chance_per_time_crew_count_looped: float = .1
    const pity_chance: float = .05
    const lucky_round_frequency: int = 3
    const lucky_round_multiplier: float = 1.3
    const required_pair_minimum: int = 2

    var applicant_chance = float(current_round) / crew_size * chance_per_time_crew_count_looped
    applicant_chance += pity_chance * rounds_since_last_applicant
    if current_round % lucky_round_frequency == 0:
        applicant_chance *= lucky_round_multiplier
    
    var applicant_count = 0
    var application_roll = randf()
    var scaling_factor = 1.2
    while applicant_chance > 0 and applicant_count < Database.MAX_APPLICANTS:
        applicant_chance -= application_roll
        if applicant_chance > 0:
            applicant_count += 1
            application_roll *= scaling_factor
    
    if applicant_count > 0:
        applicant_count = max(required_pair_minimum, applicant_count)

    return applicant_count

func _select_new_applicants(count: int) -> Array[Character]:
    var unhired_characters: Array[Character] = Database.unhired_characters
    var current_applicants: Array[Character] = Database.applicants

    var available_characters: Array[Character] = \
        unhired_characters.filter(func(x): return x not in current_applicants)
    
    if count >= available_characters.size():
        return available_characters
    else:
        var possible_indices: Array = range(available_characters.size())
        var random_selections: Array[int] = []
        for i in range(count):
            var selected_index: int = possible_indices.pick_random()
            if selected_index in random_selections:
                selected_index = possible_indices.pick_random()
            while selected_index in random_selections:
                selected_index = (selected_index + 1) % available_characters.size()
            random_selections.append(selected_index)
        
        var selected_characters: Array[Character] = []
        for idx: int in random_selections:
            selected_characters.append(available_characters[idx])
        return selected_characters

func _adjust_price(applicant: Character, _current_round: int, crew_size: int) -> void:
    const sale_odds: float = .1
    const sale_mult: float = .8
    const slight_discount_odds: float = .3
    const discount_mult: float = .95
    const normal_price_odds: float = .3
    const overpriced_mult: float = 1.1

    var new_hiring_cost: int = (crew_size + 1) * 10
    new_hiring_cost += floor(new_hiring_cost * randf_range(-.2, .2))
    var sale_percentage: float = 1.0

    var sale_roll: float = randf()
    if sale_roll < sale_odds:
        sale_percentage = sale_mult
    elif sale_roll < slight_discount_odds + sale_odds:
        sale_percentage = discount_mult
    elif sale_roll > normal_price_odds + slight_discount_odds + sale_odds:
        sale_percentage = overpriced_mult
    
    new_hiring_cost = floor(new_hiring_cost * sale_percentage)
    
    applicant.hiring_cost = new_hiring_cost

func _cycle_applicants(new_applicants: Array[Character],
        current_applicants: Array[Character]
        ) -> Array[Character]:
    new_applicants.append_array(current_applicants)
    return new_applicants.slice(0, Database.MAX_APPLICANTS)
