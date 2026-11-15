extends Control

@export var leaderboard_url: String = "https://withered99.github.io/haven-project-2.0563857/"

func _show() -> void:
	$Center/butts/play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Screen/game2.tscn")

func _on_highscores_pressed() -> void:
	OS.shell_open(leaderboard_url)

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://tutoriel.tscn")
