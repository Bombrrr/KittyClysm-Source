extends CharacterBody3D

var mouse_sensitivity := 0.003
var twist_input := 0.0
var pitch_input := 0.0

@onready var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

@onready var direction = ($TwistPivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
@onready var location = 0
@onready var length = 3
@onready var anim = $catanim/AnimationPlayer
@onready var hp = 6
@onready var in_range: bool = false
@onready var can_attack: bool = true
@onready var is_ded: bool = false

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _ready() -> void:
	$TwistPivot/PitchPivot/Camera3D.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$TwistPivot/PitchPivot/RayCast3D.add_exception($".")
	change_cam_sens()
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if is_ded:
		$catanim.rotate_y(10)
		self.global_position.y -= 0.1
	
	else:
		if global.player_hp == 0:
			$CanvasLayer/Label.show()
			_get_die()
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.

		# Get the input direction and handle the movement/deceleration.
		input_dir = Input.get_vector("move_right", "move_left", "move_back", "move_forward")
		direction = ($TwistPivot.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
		if direction:
			if not $AudioStreamPlayer2.playing:
				$AudioStreamPlayer2.play(0.3)
			anim.play("Walk Anim", -1, 10)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			self.global_rotation.y = $TwistPivot.global_rotation.y
			$TwistPivot.rotation.y = 0
		else:
			anim.play("Idle Anim")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
		deg_to_rad(-69), 
		deg_to_rad(69)
	)
	twist_input = 0.0
	pitch_input = 0.0
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$CanvasLayer.hide()
		$CanvasLayer2.show()
		get_tree().paused = true
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("attack"):
		if not global.timeout:
			$AudioStreamPlayer.play(4.8)
			$Timer.start(0.3)
			$"hit delay".start()
			global.attack_time = 0
	
	if Input.is_action_pressed("scroll in"):
		length = length - 0.5
	
	if Input.is_action_pressed("scroll out"):
		length = length + 0.5
	
	length = clamp(length, 1, 10)
	
	
	_set_camera_location(false)
	
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = event.relative.y * mouse_sensitivity

# sets camera location to either the max length or when the raycast hits an object
func _set_camera_location(debug):
	if debug:
		$TwistPivot/PitchPivot/CamPos.position.z = length
		$TwistPivot/PitchPivot/Camera3D.global_position = $TwistPivot/PitchPivot/CamPos.global_position
		
	else:
		$TwistPivot/PitchPivot/RayCast3D.set_target_position(Vector3(0, 0, length))
		if $TwistPivot/PitchPivot/RayCast3D.is_colliding() and not is_ded:
			location = $TwistPivot/PitchPivot/RayCast3D.get_collision_point()
			$TwistPivot/PitchPivot/Camera3D.global_position = location
			$TwistPivot/PitchPivot/Camera3D.position.z -= 0.25
		else:
			$TwistPivot/PitchPivot/CamPos.position.z = length
			$TwistPivot/PitchPivot/Camera3D.global_position = $TwistPivot/PitchPivot/CamPos.global_position

func _get_die():
	$AudioStreamPlayer3.play(5.9)
	$Timer.start(1)
	get_tree().queue_delete($CollisionShape3D)
	get_tree().queue_delete($Area3D)
	get_tree().queue_delete($Area3D2)
	is_ded = true
	$Death.start()


func _on_hit_delay_timeout() -> void:
	$CanvasLayer/ProgressBar.value = global.attack_time
	if global.attack_time == 100:
		global.timeout = false
		global.enemy_killed = false
	elif global.attack_time == 2:
		global.timeout = true
		global.attack_time += 2
		$"hit delay".start()
	else:
		global.attack_time += 2
		$"hit delay".start()
		
func damage():
	if global.player_hp == 5:
		$CanvasLayer/HBoxContainer/TextureRect3.queue_free()
	elif global.player_hp == 4:
		$CanvasLayer/HBoxContainer2/TextureRect3.queue_free()
	elif global.player_hp == 3:
		$CanvasLayer/HBoxContainer/TextureRect2.queue_free()
	elif global.player_hp == 2:
		$CanvasLayer/HBoxContainer2/TextureRect2.queue_free()
	elif global.player_hp == 1:
		$CanvasLayer/HBoxContainer/TextureRect.queue_free()
	else:
		$CanvasLayer/HBoxContainer2/TextureRect.queue_free()
	


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("hidden"):
		global.hidden = true


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("hidden"):
		global.hidden = false


func _on_death_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/death_screne.tscn")

func change_cam_sens():
	mouse_sensitivity = 0.003*(global.cam_sense/25)


func _on_timer_timeout() -> void:
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer3.stop()
	$CanvasLayer/HBoxContainer3/Label.text = var_to_str(global.enemies_killed)
