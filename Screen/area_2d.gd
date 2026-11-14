extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		body.queue_free()
		await get_tree().process_frame
		if get_tree().get_nodes_in_group("ball").is_empty():
			%GameOverScreen.show_game_over()
