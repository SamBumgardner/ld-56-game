class_name Gameplay extends Control

@onready var outdoor_canvas: CanvasLayer = $OutdoorBattleMode
@onready var indoor_canvas: CanvasLayer = $IndoorPrepMode
@onready var indoor_root: IndoorPreparation = $IndoorPrepMode/IndoorPreparation
@onready var transition_cover: CanvasLayer = $TransitionCover
@onready var mode_transition_cover: ModeTransitionCover = $TransitionCover/ModeTransitionCover

func go_inside():
    # we can do fancier stuff, like take a callback to only do once the screen's 
    # hidden from the calling state. We'll just make assumptions for now, since we only
    # have two states to manage.

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

func go_outside():
    # see go_inside, same idea here
    var transition_while_hidden = func():
        indoor_canvas.hide()
        outdoor_canvas.show()
    
    mode_transition_cover.hide()
    transition_cover.show()
    mode_transition_cover.fade_in_out(transition_while_hidden)