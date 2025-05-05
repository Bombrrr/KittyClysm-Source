extends Label

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("attack"):
		text = var_to_str(global.enemies_killed)
