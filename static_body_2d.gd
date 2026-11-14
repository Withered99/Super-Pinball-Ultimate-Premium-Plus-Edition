extends StaticBody2D

@export var launch_force: float = 600.0
@export var points: int = 100
@export var cooldown_time: float = 0.5

var can_score: bool = true

func _ready() -> void:
	add_to_group("bumper")
	$Area2D.body_entered.connect(_on_bumper_hit)

func _on_bumper_hit(body: Node2D) -> void:
	if body.is_in_group("ball"):
		var direction = (body.global_position - global_position).normalized()
		body.apply_impulse(direction * launch_force) 
	if not can_score:
		return
		
	can_score = false
	Global.add_score(points)
	
	await get_tree().create_timer(cooldown_time).timeout
	can_score = true
