extends Node

signal score_updated(new_score)

var score: int = 0
var _time_accumulator: float = 0.0
var is_running: bool = true

func _process(delta: float) -> void:
	if not is_running:
		return
		
	_time_accumulator += delta
	if _time_accumulator >= 1.0:
		_time_accumulator -= 1.0
		add_score(1)

func add_score(points: int) -> void:
	score += points
	score_updated.emit(score)

func reset_score() -> void:
	score = 0
	_time_accumulator = 0.0
	is_running = true
	score_updated.emit(score)

func stop_scoring() -> void:
	is_running = false
