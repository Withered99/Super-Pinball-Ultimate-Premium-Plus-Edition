extends Label

func _ready() -> void:
	text = "Score: %d" % Global.score
	Global.score_updated.connect(_on_score_updated)

func _on_score_updated(new_score: int) -> void:
	text = "Score: %d" % new_score
