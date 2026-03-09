extends Node3D

var chunk_width
var chunk_length
var chunk_height
var mat
var oilchunk
var oil_amount:int = 0
const mesh_list=[preload("res://assets/planet1/chunks/flat.obj"),preload("res://assets/planet1/chunks/mntn1.obj"),preload("res://assets/planet1/chunks/mntn2.obj"), preload("res://assets/planet1/chunks/mntn3.obj")]


func get_oil_amount() -> int:
	return oil_amount

func set_chunk(x, z, width, length, is_oilchunk) -> void:
	mat = $floor.get_surface_override_material(0).duplicate()
	$floor.set_surface_override_material(0, mat)
	$floor.mesh = mesh_list.pick_random()
	chunk_width = width
	chunk_length = length
	chunk_height = randi_range(1, 3)
	#chunk_height = 10
	position.x = x
	position.z = z
	scale = Vector3(chunk_width, chunk_height, chunk_length)
	mat.uv1_scale = Vector3(chunk_width+chunk_height, chunk_length, 1) / 4
	oilchunk = is_oilchunk
	add_to_group("chunks")
	if oilchunk:
		add_to_group("oilchunks")
		# TODO: balancing oil amount based on chunk (mesh?)
		oil_amount = 1.0 / (chunk_width + chunk_length) * 10000
		mat.albedo_color = Color(0, 0, 0) # debug
	
	#mat.albedo_color = Color(randf(), randf() ,randf()) # debug

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
