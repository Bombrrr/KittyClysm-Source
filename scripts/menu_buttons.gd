extends Button

@export var type: String




func _on_pressed() -> void:
	if type == "exit":
		get_tree().quit()
	elif type == "settings":
		get_tree().change_scene_to_file("res://scenes/settings.tscn")
	elif type == "play":
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
	elif type == "menu":
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	elif type == "howto":
		get_tree().change_scene_to_file("res://scenes/how-to.tscn")
	elif type == "close":
		$"../../../../CanvasLayer2".show()
		$"../../..".queue_free()
