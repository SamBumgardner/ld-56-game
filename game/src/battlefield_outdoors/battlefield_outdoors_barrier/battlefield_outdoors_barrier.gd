extends VBoxContainer

signal barrier_stat_type_updated

const random_display_name_adjective_list = [
    'Looming',
    'Menacing',
    'Nice',
    'Worn'
]

const random_display_name_root_list = [
    'Boulder',
    'Pyramid',
    'Security Gate'
]

@export var cost_to_overcome_number = 1
@export var display_name = ""
@export var default_graphic: Texture2D = preload("res://icon.svg")

@onready var cost_to_overcome_number_label: Label = $CostToOvercome/Amount
@onready var cost_to_overcome_stat_type_texture: TextureRect = $CostToOvercome/Symbol
@onready var display_name_label: Label = $BarrierName
@onready var barrier_texture_rect: TextureRect = $BarrierRect

## technically we don't have to store this here, but since this is the progenitor of the barrier
## it seemed handy to have around.
var current_barrier_data: BarrierData

func _ready():
    cost_to_overcome_number_label.text = str(cost_to_overcome_number)
    display_name_label.text = display_name


func _get_random_display_name() -> String:
    return (
        random_display_name_adjective_list.pick_random()
        + ' '
        + random_display_name_root_list.pick_random()
    )

func _generate_barrier_data() -> BarrierData:
    var random_display_name = _get_random_display_name()
    var random_stat_type = Database.StatType.values().pick_random()
    return BarrierData.new(random_display_name, random_stat_type,
        Database.current_barrier_cost_to_overcome_number, default_graphic)
        

func refresh() -> void:
    current_barrier_data = _generate_barrier_data()
    _update_display(current_barrier_data)

    if Database.current_barrier_stat_type_to_overcome != current_barrier_data.weakness_type:
        Database.set_current_barrier_stat_type_to_overcome(current_barrier_data.weakness_type)
        barrier_stat_type_updated.emit()
    Database.set_current_barrier_data(current_barrier_data)


func _update_display(barrier_data: BarrierData) -> void:
    if barrier_data == null:
        $CostToOvercome.visible = false
        return
    
    display_name_label.text = current_barrier_data.name
    barrier_texture_rect.texture = current_barrier_data.graphic
    cost_to_overcome_number_label.text = str(current_barrier_data.cost_to_overcome)
    cost_to_overcome_stat_type_texture.texture = Database.stat_type_to_icon[
        current_barrier_data.weakness_type
    ]

    $CostToOvercome.visible = true


func _on_battlefield_outdoors_hud_barrier_strength_scaled():
    refresh()
