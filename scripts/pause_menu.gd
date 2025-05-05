extends Button

@export var type: String
@onready var setting = preload("res://scenes/settings_in-game.tscn")
var set_i

func _on_pressed() -> void:
	if type == "resume":
		get_tree().call_group("player", "change_cam_sens")
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$"../../../CanvasLayer".show()
		$"../..".hide()
	elif type == "exit":
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	elif type == "settings":
		$"../..".hide()
		set_i = setting.instantiate()
		$"../../..".add_child(set_i)
