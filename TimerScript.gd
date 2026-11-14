extends Node2D

@onready var CardScreen = $CardScreen

func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)

var timeout_count: int = 0

func _on_timer_timeout() -> void:
	timeout_count += 1
	var is_debuff_round: bool = (timeout_count % 2 == 0)
	$CardScreen/cards.open_menu(is_debuff_round)
