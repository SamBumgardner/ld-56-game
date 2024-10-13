class_name BattlefieldOutdoorsBarrier extends Sprite2D

@export var cost_to_overcome_number = 1
@export var display_name = ""

@onready var cost_to_overcome_container: Control = $Control/CostToOvercome
@onready var cost_to_overcome_number_label: Label = $Control/CostToOvercome/Amount
@onready var cost_to_overcome_stat_type_texture: TextureRect = $Control/CostToOvercome/Symbol
@onready var display_name_label: Label = $Control/BarrierName

## technically we don't have to store this here, but since this is the progenitor of the barrier
## it seemed handy to have around.
var current_barrier_data: BarrierData

func _ready():
    Database.barrier_changed.connect(_on_barrier_changed)

    cost_to_overcome_number_label.text = String.num_int64(Database.current_barrier_cost_to_overcome_number)
    display_name_label.text = display_name

func refresh() -> void:
    _update_display(Database.current_barrier_data)

func _update_display(barrier_data: BarrierData) -> void:
    if barrier_data == null:
        cost_to_overcome_container.visible = false
        return
    
    current_barrier_data = barrier_data
    
    display_name_label.text = current_barrier_data.name
    texture = current_barrier_data.graphic
    cost_to_overcome_number_label.text = str(current_barrier_data.cost_to_overcome)
    cost_to_overcome_stat_type_texture.texture = Database.stat_type_to_icon[
        current_barrier_data.weakness_type
    ]

    cost_to_overcome_container.visible = true

func _on_barrier_changed(_new_barrier: BarrierData):
    refresh()
