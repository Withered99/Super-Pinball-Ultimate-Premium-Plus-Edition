extends AnimatableBody2D

@export var input_action: String = "ui_left"
@export var is_right_flipper: bool = false

@export var rest_angle_deg: float = 25.0
@export var active_angle_deg: float = -30.0
@export var flip_speed: float = 25.0

func _ready() -> void:
	if is_right_flipper:
		rest_angle_deg = -rest_angle_deg
		active_angle_deg = -active_angle_deg
		
	rotation_degrees = rest_angle_deg
	
	add_to_group("flipper")
	

func increase_strength(multiplier: float) -> void:
	flip_speed *= multiplier

func _physics_process(delta: float) -> void:
	var target_deg := active_angle_deg if Input.is_action_pressed(input_action) else rest_angle_deg
	
	var target_rad := deg_to_rad(target_deg)
	rotation = lerp_angle(rotation, target_rad, flip_speed * delta)
