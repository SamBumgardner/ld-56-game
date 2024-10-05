extends VBoxContainer

@export var cost_to_overcome_number = 1
@export var display_name = ""

@onready var cost_to_overcome_number_label = $CostToOvercome/Amount
@onready var display_name_label = $BarrierName

var random_display_name_adjective_list = [
    'Looming',
    'Menacing',
    'Nice',
    'Worn'
]

var random_display_name_root_list = [
    'Boulder',
    'Pyramid',
    'Security Gate'
]


func _ready():
    cost_to_overcome_number_label.text = str(cost_to_overcome_number)
    display_name_label.text = display_name


func randomize_display_name() -> void:
    display_name_label.text = (
        random_display_name_adjective_list.pick_random()
        + ' '
        + random_display_name_root_list.pick_random()
    )


func refresh() -> void:
    cost_to_overcome_number_label.text = str(
        Database.current_barrier_cost_to_overcome_number
    )
    randomize_display_name()


func _on_battlefield_outdoors_hud_barrier_strength_scaled():
    refresh()
