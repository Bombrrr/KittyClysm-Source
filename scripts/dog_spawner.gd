extends Node3D

var dog = preload("res://scenes/dog.tscn")
var tim = 1
var dog_inst

func _ready() -> void:
	$Timer.start(1)



func _on_timer_timeout() -> void:
	dog_inst = dog.instantiate()
	tim = clamp(tim/((global.enemies_killed+4)/4), 1, 40)
	$Timer.start(tim)
	tim = randi_range(10, 30)
	dog_inst.position = self.global_position
	add_sibling(dog_inst)
