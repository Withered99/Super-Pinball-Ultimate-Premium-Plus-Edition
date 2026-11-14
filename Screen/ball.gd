extends RigidBody2D

@onready var sprite: Node2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var base_sprite_scale: Vector2
var base_radius: float
var size_factor: float = 1.0

func _ready() -> void:
	add_to_group("ball")
	if sprite:
		base_sprite_scale = sprite.scale
		
	if collision and collision.shape is CircleShape2D:
		collision.shape = collision.shape.duplicate()
		base_radius = collision.shape.radius
		
	if physics_material_override == null:
		physics_material_override = PhysicsMaterial.new()
	else:
		physics_material_override = physics_material_override.duplicate()

func change_size(multiplier: float) -> void:
	size_factor = clampf(size_factor * multiplier, 0.4, 2.5)
	
	if sprite:
		sprite.scale = base_sprite_scale * size_factor
		
	if collision and collision.shape is CircleShape2D:
		collision.shape.radius = base_radius * size_factor
