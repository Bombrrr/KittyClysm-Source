extends Label


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	text = var_to_str(global.enemies_killed)
