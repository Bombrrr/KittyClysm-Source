extends TextureRect

@onready var up: bool = false
@onready var visibility = 0

func _input(event: InputEvent) -> void:
	if not global.timeout:
		if Input.is_action_just_pressed("attack"):
			up = true
func _process(delta: float) -> void:
	if up:
		if not visibility == 200:
			visibility += 10
		else:
			up = false
	elif not visibility == 0:
		visibility -= 2
	self_modulate.a8 = visibility
