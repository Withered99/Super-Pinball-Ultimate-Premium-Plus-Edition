extends Node

signal score_updated(new_score)

var score: int = 0

func add_score(points: int) -> void:
	score += points
	score_updated.emit(score)

func reset_score() -> void:
	score = 0
	score_updated.emit(score)
