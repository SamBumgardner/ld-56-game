class_name BattlefieldOutdoorsWarTransport extends Sprite2D

const HEALTH_LABEL_FORMAT: String = "%s / %s"

@onready var power: Label = $Columns/Power
@onready var health_container: Control = $Columns/HealthBar
@onready var health_bar: ProgressBar = $Columns/HealthBar/Health
@onready var health_label: Label = $Columns/HealthBar/Label
@onready var smoke_particles: CPUParticles2D = $Node2D/SmokeParticles
@onready var start_position = position

var movement_tween: Tween
var combat_stat_display_tween: Tween

func _ready() -> void:
    Database.health_changed.connect(_on_health_changed)

func charge_warmup(duration: float) -> void:
    movement_tween = clear_tween(movement_tween)
    movement_tween.tween_method(shake.bind(1, start_position, true), 0, 0, duration)

func shake(_value: float, magnitude: int, root_position: Vector2, horizontal_only: bool):
    var shake_offset = Vector2.ONE.rotated(randf_range(0, 6.29))
    if horizontal_only:
        shake_offset.y = 0
    position = root_position + (shake_offset * magnitude)

func charge_to_target(target_global_position: Vector2, duration: float) -> void:
    movement_tween = clear_tween(movement_tween)
    movement_tween.set_ease(Tween.EASE_IN)
    movement_tween.set_trans(Tween.TRANS_EXPO)
    movement_tween.tween_property(self, "global_position", target_global_position, duration)

func charge_followthrough(target_global_position: Vector2, duration: float) -> void:
    movement_tween = clear_tween(movement_tween)
    movement_tween.set_ease(Tween.EASE_OUT)
    movement_tween.set_trans(Tween.TRANS_CUBIC)
    movement_tween.tween_property(self, "global_position", target_global_position, duration)

func defeated_knockback(duration: float) -> void:
    const knockback_distance = Vector2(-200, 0)
    movement_tween = clear_tween(movement_tween)
    movement_tween.set_ease(Tween.EASE_OUT)
    movement_tween.set_trans(Tween.TRANS_CIRC)
    movement_tween.tween_callback(smoke_particles.restart)
    movement_tween.tween_property(self, "global_position", global_position + knockback_distance / 3, duration / 4)
    movement_tween.parallel()
    movement_tween.tween_property(self, "rotation", -.4, duration / 4)
    movement_tween.tween_interval(duration / 8)
    movement_tween.tween_callback(smoke_particles.restart)
    movement_tween.tween_property(self, "global_position", global_position + knockback_distance, duration / 2)
    movement_tween.parallel()
    movement_tween.tween_property(self, "rotation", .6, duration / 2)
    movement_tween.tween_interval(duration / 4)
    movement_tween.tween_callback(smoke_particles.restart)
    movement_tween.tween_property(self, "global_position", global_position + knockback_distance * 2, duration * 7 / 8)
    movement_tween.parallel()
    movement_tween.tween_property(self, "rotation", -.8, duration * 7 / 8)

func return_to_start_position(duration: float) -> void:
    movement_tween = clear_tween(movement_tween)
    movement_tween.tween_property(self, "position", start_position, duration)

func create_destruction_tweens(duration: float):
    movement_tween = clear_tween(movement_tween)
    movement_tween.tween_method(shake.bind(2, position, false), 0, 0, duration)

    var disappear_tween = create_tween()
    disappear_tween.tween_property(self, "modulate", Color.TRANSPARENT, duration)
    disappear_tween.tween_callback(hide)

func clear_tween(tween: Tween) -> Tween:
    if tween != null and tween.is_running():
        tween.kill()
    
    return create_tween()

func scale_power_display_font_size(power_value: int) -> void:
    const font_size_multiplier: int = 3
    const font_size_min: int = 16
    const font_size_max: int = 256

    var font_size = clamp(
        power_value * font_size_multiplier,
        font_size_min,
        font_size_max)

    power.set("theme_override_font_sizes/font_size", font_size)

func _on_health_changed(_new_value: int, _old_value: int) -> void:
    update_health_display_values()

func update_health_display_values() -> void:
    var max_health = Database.war_transport_health_maximum
    var current_health = Database.war_transport_health_current
    health_bar.max_value = max_health
    health_bar.value = current_health
    health_label.text = HEALTH_LABEL_FORMAT % [current_health, max_health]

func display_combat_stats(power_value: int, duration: float):
    update_health_display_values()
    scale_power_display_font_size(power_value)
    power.text = String.num_int64(power_value)
    power.modulate = Color.TRANSPARENT
    health_container.modulate = Color.TRANSPARENT

    if combat_stat_display_tween != null and combat_stat_display_tween.is_valid():
        combat_stat_display_tween.stop()
    combat_stat_display_tween = create_tween()
    combat_stat_display_tween.tween_callback(power.show)
    combat_stat_display_tween.tween_callback(health_container.show)
    combat_stat_display_tween.tween_property(
        power,
        "modulate",
        Color.WHITE,
        duration
    )
    combat_stat_display_tween.parallel()
    combat_stat_display_tween.tween_property(
        health_container,
        "modulate",
        Color.WHITE,
        duration
    )

func hide_power(duration: float):
    power.modulate = Color.WHITE

    if combat_stat_display_tween != null and combat_stat_display_tween.is_valid():
        combat_stat_display_tween.stop()
    combat_stat_display_tween = create_tween()
    combat_stat_display_tween.tween_property(
        power,
        "modulate",
        Color.TRANSPARENT,
        duration
    )
    combat_stat_display_tween.parallel()
    combat_stat_display_tween.tween_property(
        health_container,
        "modulate",
        Color.TRANSPARENT,
        duration
    )
    combat_stat_display_tween.tween_callback(power.hide)
    combat_stat_display_tween.tween_callback(health_container.hide)
