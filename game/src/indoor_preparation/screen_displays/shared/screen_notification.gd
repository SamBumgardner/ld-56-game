class_name ScreenNotification extends Control

enum ScreenNotificationType {
    NOTIFY,
    ERROR,
}

signal notification_expired()

@onready var expiration_timer: Timer = $ExpirationTimer
@onready var header: Label = $PC/MC/VBC/Header
@onready var body: Label = $PC/MC/VBC/PC2/MC2/VBC2/Body
@onready var expiration_bar: ProgressBar = $PC/MC/VBC/PC2/MC2/VBC2/ExpirationBar
var expiration_max: float

func _ready() -> void:
    if self == get_tree().current_scene:
        display_notification(ScreenNotificationType.NOTIFY, "This is a test notification", 3)

func display_notification(notification_type: ScreenNotificationType, body_text: String,
        duration: float) -> void:
    match notification_type:
        ScreenNotificationType.NOTIFY:
            header.text = "Notification"
            #TODO: set theme to be normal
        ScreenNotificationType.ERROR:
            header.text = "ERROR"
            #TODO: set theme to be "error" red and whatnot
    body.text = body_text
    expiration_max = duration
    expiration_bar.max_value = expiration_max
    expiration_bar.value = expiration_max
    show()
    
    expiration_timer.one_shot = true
    expiration_timer.start(duration)

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
