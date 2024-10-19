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
var start_global_position: Vector2
var anchor_global_position: Vector2:
    set(value):
        anchor_global_position = value
        global_position = value
var position_tween: Tween
var disappear_tween: Tween
var power_fade_in_tween: Tween

func _ready():
    start_global_position = global_position
    anchor_global_position = global_position
    Database.barrier_changed.connect(_on_barrier_changed)

    cost_to_overcome_number_label.text = String.num_int64(Database.current_barrier_cost_to_overcome_number)
    display_name_label.text = display_name

func refresh() -> void:
    _update_display(Database.current_barrier_data)

func _update_display(barrier_data: BarrierData) -> void:
    current_barrier_data = barrier_data
    
    display_name_label.text = current_barrier_data.name
    texture = current_barrier_data.graphic
    cost_to_overcome_number_label.text = String.num_int64(current_barrier_data.cost_to_overcome)
    cost_to_overcome_stat_type_texture.texture = Database.stat_type_to_icon[
        current_barrier_data.weakness_type
    ]

func _on_barrier_changed(_new_barrier: BarrierData):
    refresh()

func scale_power_display_font_size() -> void:
    const font_size_multiplier: int = 3
    const font_size_min: int = 16
    const font_size_max: int = 108

    var font_size = clamp(
        current_barrier_data.cost_to_overcome * font_size_multiplier,
        font_size_min,
        font_size_max)

    cost_to_overcome_number_label.set("theme_override_font_sizes/font_size", font_size)

func display_power(duration: float):
    scale_power_display_font_size()
    cost_to_overcome_container.modulate = Color.TRANSPARENT

    if power_fade_in_tween != null and power_fade_in_tween.is_valid():
        power_fade_in_tween.stop()
    power_fade_in_tween = create_tween()
    power_fade_in_tween.tween_callback(cost_to_overcome_container.show)
    power_fade_in_tween.tween_property(
        cost_to_overcome_container,
        "modulate",
        Color.WHITE,
        duration
    )

func animate_destruction(duration) -> void:
    if position_tween != null and position_tween.is_valid():
        position_tween.stop()
    _create_destruction_tweens(duration)

func new_barrier_scroll_onscreen(duration: float, spawn_offset: Vector2) -> void:
    anchor_global_position = start_global_position + spawn_offset
    cost_to_overcome_container.hide()
    show()
    modulate = Color.WHITE

    if position_tween != null and position_tween.is_valid():
        position_tween.stop()
    if disappear_tween != null and disappear_tween.is_valid():
        disappear_tween.stop()
    position_tween = create_tween()
    position_tween.tween_property(self, "anchor_global_position", start_global_position, duration)

func _create_destruction_tweens(duration: float):
    if position_tween != null and position_tween.is_valid():
        position_tween.stop()
    position_tween = create_tween()
    position_tween.tween_method(horizontal_shake, 0, 0, duration)

    if disappear_tween != null and disappear_tween.is_valid():
        disappear_tween.stop()
    disappear_tween = create_tween()
    disappear_tween.tween_interval(duration / 2)
    disappear_tween.tween_property(self, "modulate", Color.TRANSPARENT, duration / 2)
    disappear_tween.tween_callback(hide)

func horizontal_shake(_value: float):
    var shake_offset = Vector2.ONE.rotated(randf_range(0, 6.29))
    shake_offset.y = 0
    var magnitude = 5
    global_position = anchor_global_position + (shake_offset * magnitude)
