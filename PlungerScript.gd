extends AnimatableBody2D

@export var max_pull_distance: float = 80.0
@export var pull_speed: float = 60.0
@export var release_speed: float = 800.0
@export var max_launch_force: float = 1600.0

@onready var launch_zone: Area2D = $LaunchZone

var start_y: float
var current_pull: float = 0.0

func _ready() -> void:
	start_y = position.y

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		current_pull = move_toward(current_pull, max_pull_distance, pull_speed * delta)
	
	elif Input.is_action_just_released("ui_accept") and current_pull > 0.0:
		launch_ball()
		current_pull = 0.0
		
	else:
		position.y = move_toward(position.y, start_y, release_speed * delta)
		return

	position.y = start_y + current_pull

func launch_ball() -> void:
	var charge_ratio := current_pull / max_pull_distance
	var force := charge_ratio * max_launch_force
	
	for body in launch_zone.get_overlapping_bodies():
		if body is RigidBody2D:
			body.apply_central_impulse(Vector2.UP * force)
