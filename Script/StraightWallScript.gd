@tool
extends StaticBody2D

@export var length: float = 300.0:
	set(value):
		length = value
		_update_wall()

@export var thickness: float = 30.0:
	set(value):
		thickness = value
		_update_wall()

func _ready() -> void:
	_update_wall()

func _update_wall() -> void:
	if not is_inside_tree():
		return
		
	var half_len: float = length * 0.5
	var half_thick: float = thickness * 0.5
	
	var points := PackedVector2Array([
		Vector2(-half_len, -half_thick),
		Vector2(half_len, -half_thick),
		Vector2(half_len, half_thick),
		Vector2(-half_len, half_thick)
	])
	
	if has_node("CollisionPolygon2D"):
		$CollisionPolygon2D.polygon = points
	if has_node("Polygon2D"):
		$Polygon2D.polygon = points
