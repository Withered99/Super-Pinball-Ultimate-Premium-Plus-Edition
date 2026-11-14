extends StaticBody2D

@export var launch_force: float = 600.0

func _ready() -> void:
	$Area2D.body_entered.connect(_on_bumper_hit)

func _on_bumper_hit(body: Node2D) -> void:
	if body.is_in_group("ball"):
		var direction = (body.global_position - global_position).normalized()
		body.apply_impulse(direction * launch_force) 
		
	
		
