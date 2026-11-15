extends Control

func _show() -> void:
	$Center/butts/play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Screen/game2.tscn")

func _on_highscores_pressed() -> void:
	get_tree().reload_current_scene() 


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://tutoriel.tscn")
