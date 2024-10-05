extends Control


func _on_exit_button_pressed():
    get_tree().change_scene_to_file("res://src/start_menu/StartMenu.tscn")
