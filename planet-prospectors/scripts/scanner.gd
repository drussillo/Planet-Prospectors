extends Node3D

var velocityY = 0
var velocityYdelta = 0.00025
var playerchunk

const TIMEOUT = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _update_distance_indicator(text) -> void:
	$scannermodel/screen/distance_indicator.text = str(text, "m")

# Called every frame. 'delta' is the elapsed time since the previous frame.6
func _process(delta: float) -> void:
	velocityY += velocityYdelta * delta
	if velocityY > 0.0002 || velocityY < -0.0002:
		velocityYdelta *= -1
		
	var closest_chunk = get_tree().get_first_node_in_group("oilchunks")
	var min_distance = global_position.distance_to(closest_chunk.global_position)
	if Input.is_action_just_pressed("scan") && !$scantimer.time_left > 0:
		$scantimer.start()
		for chunk in get_tree().get_nodes_in_group("oilchunks"):
			var current_distance = global_position.distance_to(chunk.global_position) - (chunk.chunk_width + chunk.chunk_length) / 4
			if min_distance > current_distance && chunk.oil_amount > 0:
				min_distance = current_distance
				closest_chunk = chunk
	
		if min_distance <= 0:
			min_distance = 0
			
		_update_distance_indicator(str(int(min_distance)))
		if closest_chunk.oil_amount > 0:
			$scannermodel/screen/pivot.visible = true
		else:
			$scannermodel/screen/pivot.visible = false
		$scannermodel/screen/pivot.look_at(closest_chunk.global_position, Vector3.UP)
		$scannermodel/screen/pivot.rotation.x = 0
		$scannermodel/screen/pivot.rotation.z = 0
	
	var mat = $scannermodel/screen/timerindicator.get_active_material(0)
	mat.set_shader_parameter("progress", 1.0/TIMEOUT * $scantimer.time_left)
	print(1.0/TIMEOUT * $scantimer.time_left)
	if playerchunk != null:
		if playerchunk.oilchunk && playerchunk.oil_amount > 0:
			$scannermodel/screen.get_active_material(0).albedo_color = Color(0, 0.9, 0)
		elif playerchunk.oilchunk && playerchunk.oil_amount == 0:
			$scannermodel/screen.get_active_material(0).albedo_color = Color(0.9, 0, 0)
		else:
			$scannermodel/screen.get_active_material(0).albedo_color = Color(0, 0, 0)
	
	position.y += velocityY
