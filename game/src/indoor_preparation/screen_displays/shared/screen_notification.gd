class_name ScreenNotification extends Control

enum ScreenNotificationType {
    NOTIFY,
    ERROR,
    CHECKPOINT,
}

signal notification_expired()

const inner_modulate_info: Color = Color(0.475, 0.498, 0.671)
const inner_modulate_error: Color = Color(0.752, 0.401, 0.28)
const inner_modulate_checkpoint: Color = Color(0.383, 0.572, 0.302)
const theme_info: Theme = preload("res://assets/themes/Notification_Info.tres")
const theme_error: Theme = preload("res://assets/themes/Notification_Error.tres")
const theme_checkpoint: Theme = preload("res://assets/themes/Notification_Checkpoint.tres")

@onready var expiration_timer: Timer = $ExpirationTimer
@onready var header: Label = $PC/MC/VBC/Header
@onready var body: Label = $PC/MC/VBC/PC2/MC2/VBC2/Body
@onready var close_button: Button = $PC/MC/VBC/PC2/MC2/VBC2/Button
@onready var expiration_bar: ProgressBar = $PC/MC/VBC/PC2/MC2/VBC2/Button/ExpirationBar
@onready var inner_panel: PanelContainer = $PC/MC/VBC/PC2

@onready var start_position: Vector2 = self.position
var expiration_max: float
var shake_tween: Tween

var notification_queue: Array[Callable] = []

func _ready() -> void:
    close_button.pressed.connect(cancel)
    if self == get_tree().current_scene:
        display_notification(ScreenNotificationType.NOTIFY, "This is a test notification", 3)

func display_notification(notification_type: ScreenNotificationType, body_text: String,
        duration: float) -> void:
    match notification_type:
        ScreenNotificationType.NOTIFY:
            header.text = "Notification"
            theme = theme_info
            inner_panel.self_modulate = inner_modulate_info
        ScreenNotificationType.ERROR:
            header.text = "ERROR"
            theme = theme_error
            inner_panel.self_modulate = inner_modulate_error
            _create_shake_tween()
        ScreenNotificationType.CHECKPOINT:
            header.text = "Checkpoint"
            theme = theme_checkpoint
            inner_panel.self_modulate = inner_modulate_checkpoint
    body.text = body_text
    expiration_max = duration
    expiration_bar.max_value = expiration_max
    expiration_bar.value = expiration_max
    show()
    
    expiration_timer.one_shot = true
    expiration_timer.start(duration)

# note: this won't play nice with some parts of how Indoors is set up right now
func queue_notification(notification_type: ScreenNotificationType, body_text: String,
        duration: float) -> void:
    notification_queue.append(display_notification.bind(notification_type, body_text,
        duration))

func cancel():
    if visible:
        notification_expired.emit()
        hide()

func _process(_delta: float) -> void:
    if not expiration_timer.is_stopped():
        expiration_bar.value = expiration_timer.time_left
    elif visible:
        notification_expired.emit()
        hide()

    if notification_queue.size() > 0:
        notification_queue.pop_front().call()

func _create_shake_tween():
    if shake_tween != null and shake_tween.is_valid():
        shake_tween.stop()
    shake_tween = create_tween()
    shake_tween.tween_method(shake_notification_window, 0, 0, .1)
    shake_tween.tween_property(self, "position", start_position, 0)

func shake_notification_window(_value: float):
    position = start_position + (Vector2.ONE.rotated(randf_range(0, 6.29)) * 5)
