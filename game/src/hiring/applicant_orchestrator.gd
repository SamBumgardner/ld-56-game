class_name ApplicantOrchestrator extends Node

signal new_applicants_arrived(new_applicants: Array[Character])

func update_applicants(current_round: int):
    var current_applicants: Array[Character] = Database.applicants
    var crew_size: int = Database.hired_character_count

    if current_applicants.size() > 1:
        var num_to_remove: int = _calculate_leave_count()
        current_applicants = _pop_back_applicants(current_applicants, num_to_remove)
    
    var num_to_add: int = _calculate_applicant_count(current_round, crew_size)
    if num_to_add > 0:
        var new_applicants: Array[Character] = _select_new_applicants(num_to_add)
        for applicant: Character in new_applicants:
            _adjust_price(applicant, current_round, crew_size)
        _cycle_applicants(new_applicants, current_applicants)

        new_applicants_arrived.emit(new_applicants)

func _calculate_leave_count() -> int:
    return 0

func _pop_back_applicants(
        current_applicants: Array[Character],
        number_to_remove: int
        ) -> Array[Character]:
    return []

func _calculate_applicant_count(current_round: int, crew_size: int) -> int:
    return 0

func _select_new_applicants(count: int) -> Array[Character]:
    return []

func _adjust_price(applicant: Character, current_round: int, crew_size: int) -> void:
    pass

func _cycle_applicants(new_applicants: Array[Character],
        current_applicants: Array[Character]
        ) -> Array[Character]:
    return []
