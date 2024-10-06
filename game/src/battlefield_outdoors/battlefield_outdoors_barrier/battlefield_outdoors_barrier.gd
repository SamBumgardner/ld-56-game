extends VBoxContainer

@export var action = null
@export var cost_to_overcome_number = 1
@export var display_name = ""

@onready var cost_to_overcome_number_label = $CostToOvercome/Amount
@onready var cost_to_overcome_stat_type_texture = $CostToOvercome/Symbol
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


func _get_random_display_name() -> String:
    return (
        random_display_name_adjective_list.pick_random()
        + ' '
        + random_display_name_root_list.pick_random()
    )


func refresh() -> void:
    var random_display_name = _get_random_display_name()
    var random_stat_type = Database.StatType.values().pick_random()

    display_name_label.text = random_display_name
    var overcome_action = Action.new(
        random_display_name,
        random_stat_type,
        Database.current_barrier_cost_to_overcome_number
    )
    set_action(overcome_action)


func set_action(action: Action) -> void:
    if action == null:
        $CostToOvercome.visible = false
        return

    cost_to_overcome_number_label.text = str(action.amount)
    cost_to_overcome_stat_type_texture.texture = Database.stat_type_to_icon[
        action.stat_type
    ]
    Database.set_current_barrier_stat_type_to_overcome(action.stat_type)
    $CostToOvercome.visible = true


func _on_battlefield_outdoors_hud_barrier_strength_scaled():
    refresh()
