extends Control

var ball_scene: PackedScene = preload("res://Screen/ball.tscn")
@export var spawn_position: Vector2 = Vector2(1032.0, 470.0)

@onready var cards: Array[Button] = [
	$Center/butts/card1,
	$Center/butts/card2,
	$Center/butts/card3
]

var upgrade_options: Array[Dictionary] = [
	{"title": "Stronger Flippers", "effect": _stronger_flippers, "weight": 10, "rare": false},
	{"title": "Bigger Balls", "effect": _bigger_balls, "weight": 10, "rare": false},
	{"title": "Bouncier Balls", "effect": _bouncier_balls, "weight": 10, "rare": false},
	{"title": "Lighter Balls", "effect": _lighter_balls, "weight": 8, "rare": false},
	{"title": "Bonus Ball", "effect": _bonus_ball, "weight": 4, "rare": true},
	{"title": "2x Points (Permanent)", "effect": _double_points, "weight": 2, "rare": true}
]

var debuff_options: Array[Dictionary] = [
	{"title": "Weaker Flippers", "effect": _weaker_flippers, "weight": 10, "rare": false},
	{"title": "Smaller Balls", "effect": _smaller_balls, "weight": 10, "rare": false},
	{"title": "Less Bouncy Balls", "effect": _less_bouncy_balls, "weight": 10, "rare": false},
	{"title": "Heavier Balls", "effect": _heavier_balls, "weight": 8, "rare": false},
	{"title": "Slippery Flippers", "effect": _slippery_flippers, "weight": 5, "rare": true}
]

var active_choices: Array[Dictionary] = []

func open_menu(is_debuff: bool = false) -> void:
	get_tree().paused = true
	visible = true
	_roll_cards(is_debuff)
	cards[0].grab_focus()

func _close_menu() -> void:
	get_tree().paused = false
	visible = false

func _roll_cards(is_debuff: bool) -> void:
	var source_list := debuff_options if is_debuff else upgrade_options
	var pool := source_list.duplicate()
	active_choices.clear()
	
	# Pick 3 unique cards using weighted random chance
	for i in range(cards.size()):
		if pool.is_empty():
			break
		var picked := _pick_weighted_card(pool)
		active_choices.append(picked)
		pool.erase(picked) # Remove so the same card can't appear twice in one hand
		
		cards[i].text = picked["title"]
		if is_debuff:
			cards[i].modulate = Color(1.0, 0.35, 0.35) if picked["rare"] else Color(1.0, 0.65, 0.65)
		else:
			cards[i].modulate = Color(1.0, 0.85, 0.25) if picked["rare"] else Color.WHITE

func _pick_weighted_card(pool: Array[Dictionary]) -> Dictionary:
	var total_weight: int = 0
	for item in pool:
		total_weight += item["weight"]
		
	var roll: int = randi_range(1, total_weight)
	var current: int = 0
	for item in pool:
		current += item["weight"]
		if roll <= current:
			return item
	return pool[0]

func _on_card_1_pressed() -> void:
	_apply_choice(0)

func _on_card_2_pressed() -> void:
	_apply_choice(1)

func _on_card_3_pressed() -> void:
	_apply_choice(2)

func _apply_choice(index: int) -> void:
	active_choices[index]["effect"].call()
	_close_menu()

# --- Upgrade Effects ---
func _stronger_flippers() -> void:
	get_tree().call_group("flipper", "increase_strength", 1.25)

func _bigger_balls() -> void:
	get_tree().call_group("ball", "change_size", 1.2)

func _bonus_ball() -> void:
	var new_ball := ball_scene.instantiate()
	get_tree().current_scene.add_child(new_ball)
	new_ball.global_position = spawn_position

func _bouncier_balls() -> void:
	get_tree().call_group("ball", "change_bounce", 0.15)

func _lighter_balls() -> void:
	get_tree().call_group("ball", "change_weight", 0.75)

func _double_points() -> void:
	Global.double_multiplier()

# --- Debuff Effects ---
func _weaker_flippers() -> void:
	get_tree().call_group("flipper", "increase_strength", 0.8)

func _smaller_balls() -> void:
	get_tree().call_group("ball", "change_size", 0.8)

func _less_bouncy_balls() -> void:
	get_tree().call_group("ball", "change_bounce", -0.15)

func _heavier_balls() -> void:
	get_tree().call_group("ball", "change_weight", 1.35)

func _slippery_flippers() -> void:
	get_tree().call_group("flipper", "make_slippery")
