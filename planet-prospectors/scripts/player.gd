extends CharacterBody3D


signal oil_changed(current, objective)

#const SPEED = 4.0
const SPEED = 10.0 # debug speed
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.001

const DRILL_SCENE = preload("res://scenes/drill.tscn")
const DRILL_DISTANCE = 3

var head_bob_speed = 0.01
@onready var head_distance = $Head.global_position.y - global_position.y

var current_chunk
var current_oil = 0
var drilling = false
var drill
const OBJECTIVE = 1000
var soundstopped = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# TODO: spawn on surface / spawn on rocket, then land
	global_position.y = 5
	
func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENS)
		$Head.rotate_x(-event.relative.y * MOUSE_SENS)
		$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-80), deg_to_rad(80))


func _physics_process(delta: float) -> void:
	# Quit
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if is_on_floor():
			var distance = abs($Head.global_position.y - global_position.y - head_distance)
			if distance > head_distance/12:
				head_bob_speed *= -1
			$Head.position.y += head_bob_speed
			if !$footsteps.playing:
				$footsteps.play()
	else:
		$footsteps.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if is_on_floor():
			$Head.position.y = global_position.y + head_distance
	
	if Input.is_action_just_pressed("interact"):
		if !drilling:
			soundstopped = false
			drill = DRILL_SCENE.instantiate()
			drill.position = global_transform.origin - global_transform.basis.z.normalized() * DRILL_DISTANCE
			drill.position.y = -10
			add_sibling(drill)
			drill.chunk = current_chunk
			drilling = true
		elif global_position.distance_to(drill.global_position) < DRILL_DISTANCE*2:
			drill.get_node("placesound").play()
			await drill.get_node("placesound").finished
			drill.queue_free()
			drilling = false
		else:
			# TODO: play drill too far sound / hint
			pass

	if drilling:
		if drill.chunk.oil_amount > 0:
			if !drill.get_node("drillingsound").is_playing():
				drill.get_node("drillingsound").play()
			drill.chunk.oil_amount -= 1;
			current_oil += 1;
		else:
			drill.get_node("drillingsound").stop()
			if !drill.get_node("stopsound").is_playing() and !soundstopped:
				drill.get_node("stopsound").play()
				soundstopped = true
			#drilling = false
		print(drill.chunk.oil_amount, "  ", current_oil)

	# give player location to scanner
	$Head/Scanner.playerchunk = current_chunk
	
	# print(current_chunk.oil_amount, "  ", current_oil)
	oil_changed.emit(current_oil, 0)
	
	
	if current_oil >= OBJECTIVE && drilling && drill.chunk.oil_amount == 0:
		drill.velocityY += 0.00001
		drill.velocityY *= 1.05
		# TODO: add winstate

	print(current_chunk.oil_amount, "  ", current_oil)
	oil_changed.emit(current_oil, OBJECTIVE)

	move_and_slide()
