extends CharacterBody3D

@onready var nav = $NavigationAgent3D
@onready var anim = $dog_updatedc3/AnimationPlayer
@onready var in_range: bool = false
@onready var can_attack: bool = true
@onready var in_attack: bool = false
@onready var is_dead: bool = false
@onready var fly: bool = false

var SPEED = 3.0

func _physics_process(delta: float) -> void:
	if not is_dead:
		if global.player_hp == 0:
			is_dead = true
			get_tree().queue_delete($CollisionShape3D)
			get_tree().queue_delete($CollisionShape3D2)
			get_tree().queue_delete($Area3D)
			$Timer.stop()
			$wait.start()
			
		anim.play("ArmatureAction")
		var current_loc =  global_transform.origin
		var next_loc = nav.get_next_path_position()
		var new_vel = (next_loc - current_loc).normalized() * SPEED
		look_at(Vector3(next_loc.x, global_position.y, next_loc.z))
		
		if in_range:
			if can_attack:
				can_attack = false
				$Timer.start()
		
		if not in_range:
			can_attack = true
			$Timer.stop()
		
		
		velocity = new_vel
		if not global.hidden:
			move_and_slide()
		
	else:
		self.rotate_y(10)
		if fly:
			self.global_position.y += 0.1
		
func update_location(target_location):
	nav.target_position = target_location

func _input(event: InputEvent) -> void:
	if not is_dead:
		if in_attack:
			if Input.is_action_just_pressed("attack"):
				if not global.timeout:
					if not global.enemy_killed:
						global.enemies_killed += 1
						global.enemy_killed = true
						is_dead = true
						$AudioStreamPlayer.play()
						#$CollisionShape3D.queue_free()
						$CollisionShape3D2.queue_free()
						$Area3D.queue_free()
						$Timer.stop()
						$wait.start()

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		in_range = true

func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("player"):
		in_range = false


func _on_timer_timeout() -> void:
	can_attack = true
	if not global.player_hp == 0:
		global.player_hp -= 1
		get_tree().call_group("player", "damage")

func _on_ded_tim_timeout() -> void:
	get_tree().queue_delete(self)


func _on_wait_timeout() -> void:
	fly = true
	$ded_tim.start()


func _on_area_3d_2_area_entered(area: Area3D) -> void:
	if area.is_in_group("hurt"):
		in_attack = true


func _on_area_3d_2_area_exited(area: Area3D) -> void:
	if area.is_in_group("hurt"):
		in_attack = false
