@tool
extends StaticBody2D

@export var radius: float = 200.0:
	set(value):
		radius = value
		_update_arch()

@export var thickness: float = 30.0:
	set(value):
		thickness = value
		_update_arch()

@export_range(10.0, 360.0) var arc_angle_deg: float = 180.0:
	set(value):
		arc_angle_deg = value
		_update_arch()

@export_range(8, 128) var segments: int = 32:
	set(value):
		segments = value
		_update_arch()

func _ready() -> void:
	_update_arch()

func _update_arch() -> void:
	if not is_inside_tree():
		return
		
	var outer_points := PackedVector2Array()
	var inner_points := PackedVector2Array()
	var center_points := PackedVector2Array()
	
	var start_angle := -PI
	var end_angle := start_angle + deg_to_rad(arc_angle_deg)
	var mid_radius := radius + (thickness * 0.5)
	
	for i in range(segments + 1):
		var t := float(i) / segments
		var angle: float = lerp(start_angle, end_angle, t)
		var dir := Vector2(cos(angle), sin(angle))
		
		outer_points.append(dir * (radius + thickness))
		inner_points.append(dir * radius)
		center_points.append(dir * mid_radius)
		
	inner_points.reverse()
	
	if has_node("CollisionPolygon2D"):
		$CollisionPolygon2D.polygon = outer_points + inner_points
		
	if has_node("Line2D"):
		$Line2D.width = thickness
		$Line2D.points = center_points
