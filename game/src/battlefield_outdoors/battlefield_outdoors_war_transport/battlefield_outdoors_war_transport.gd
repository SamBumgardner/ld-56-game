extends Node2D


func _on_battlefield_outdoors_hud_dice_roll_requested():
    _roll_dice()


func _roll_dice():
    $VBoxContainer/GridOfDiceResults.roll_dice()
