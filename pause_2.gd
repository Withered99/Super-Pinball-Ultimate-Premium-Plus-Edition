extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_indent"):
		get_viewport().set_input_as_handled()
		_set_paused(not get_tree().paused)
			
			
func _set_paused(value: bool) -> void:
	get_tree().paused = value
	visible = value
	if value: 
		$Center/butts/resume.grab_focus()

func _on_resume_pressed() -> void:
	_set_paused(false)  


func _on_restart_pressed() -> void:
	_set_paused(false)
	get_tree().reload_current_scene() 
