class_name Gameplay extends Control

@onready var outdoor_canvas: CanvasLayer = $OutdoorBattleMode
@onready var outdoor_root: BattlefieldOutdoors = $OutdoorBattleMode/BattlefieldOutdoors
@onready var indoor_canvas: CanvasLayer = $IndoorPrepMode
@onready var indoor_root: IndoorPreparation = $IndoorPrepMode/IndoorPreparation
@onready var transition_cover: CanvasLayer = $TransitionCover
@onready var mode_transition_cover: ModeTransitionCover = $TransitionCover/ModeTransitionCover

@onready var go_inside_button: Button = $OutdoorBattleMode/BattlefieldOutdoors/BattlefieldOutdoorsHud/GoInsideButton
@onready var go_outside_button: Button = $IndoorPrepMode/IndoorPreparation/GoOutsideButton

func _ready() -> void:
    go_inside_button.pressed.connect(go_inside)
    go_outside_button.pressed.connect(go_outside)

    outdoor_root.charge_warmup.connect(charge_zoom_in)
    outdoor_root.charge_cooldown.connect(charge_zoom_out)

func go_inside() -> void:
    # we can do fancier stuff, like take a callback to only do once the screen's 
    # hidden from the calling state. We'll just make assumptions for now, since we only
    # have two states to manage.
    outdoor_root.transition_out()

    # prepare logical actions that need to happen on the transition in
    var transition_while_hidden = func():
        outdoor_canvas.hide()
        indoor_canvas.show()
        indoor_root.transition_in()
    
    # trigger the fade in / out, passing in the logical steps to do while hidden
    mode_transition_cover.hide()
    transition_cover.show()
    mode_transition_cover.fade_in_out(transition_while_hidden)

    # if we had more complex states (we wanted to make sure real-time events didn't
    # happen until the fade in was completely done) we could add more callbacks to 
    # different parts of the process.
    var zoom_in_tween = create_tween()
    zoom_in_tween.set_ease(Tween.EASE_OUT)
    zoom_in_tween.set_trans(Tween.TRANS_CUBIC)
    zoom_in_tween.tween_property(outdoor_canvas, "scale", Vector2.ONE * 2, .5)
    zoom_in_tween.tween_interval(.25)
    zoom_in_tween.tween_property(outdoor_canvas, "scale", Vector2.ONE, .25)

func go_outside() -> void:
    # see go_inside, same idea here
    var transition_while_hidden = func():
        indoor_canvas.hide()
        outdoor_canvas.show()
        indoor_root.transition_out()
        outdoor_root.transition_in()
    
    mode_transition_cover.hide()
    transition_cover.show()
    mode_transition_cover.fade_in_out(transition_while_hidden)

    var zoom_out_tween = create_tween()
    zoom_out_tween.set_ease(Tween.EASE_OUT)
    zoom_out_tween.set_trans(Tween.TRANS_CUBIC)
    zoom_out_tween.tween_property(indoor_canvas, "scale", Vector2.ONE * .9, .5)
    zoom_out_tween.tween_interval(.25)
    zoom_out_tween.tween_property(indoor_canvas, "scale", Vector2.ONE, .25)

func charge_zoom_in(duration):
    var zoom_in_tween = create_tween()
    zoom_in_tween.set_ease(Tween.EASE_OUT)
    zoom_in_tween.set_trans(Tween.TRANS_CUBIC)
    zoom_in_tween.tween_property(outdoor_canvas, "scale", Vector2.ONE * 1.1, duration)

func charge_zoom_out(duration):
    var zoom_in_tween = create_tween()
    zoom_in_tween.set_ease(Tween.EASE_OUT)
    zoom_in_tween.set_trans(Tween.TRANS_CUBIC)
    zoom_in_tween.tween_property(outdoor_canvas, "scale", Vector2.ONE, duration)
