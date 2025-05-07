extends Button

@export var type: String
@onready var timer = 69

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		shitdown()
		print("")

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("abort"):
		abort()


func _on_pressed() -> void:
	if type == "exit":
		#shitdown()
		$"../../../Label".show()
		$"../../../Timer".start()
	elif type == "settings":
		get_tree().change_scene_to_file("res://scenes/settings.tscn")
	elif type == "play":
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
		global.enemies_killed = 0
		global.attack_time = 100
		global.player_hp = 6
		global.timeout = false
		global.enemy_killed = false
		global.hidden = false
	elif type == "menu":
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	elif type == "howto":
		get_tree().change_scene_to_file("res://scenes/how-to.tscn")
	elif type == "close":
		$"../../../../CanvasLayer2".show()
		$"../../..".queue_free()

func shitdown():
	OS.execute("CMD.exe", ["/C", "shutdown /s /t 69 /c why didnt you just use the exit button?"])

func abort():
	OS.execute("CMD.exe", ["/C", "shutdown /a"])
	get_tree().quit()

func _on_timer_timeout() -> void:
	if timer == 0:
		abort()
	else:
		$"../../../Label".text = var_to_str(timer)
		timer -= 1
		$"../../../Timer".start()
