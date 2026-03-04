extends Node3D

var chunk_width
var chunk_length
var chunk_height
var mat


func set_chunk(x, z, width, length) -> void:
	mat = $floor.get_surface_override_material(0).duplicate()
	$floor.set_surface_override_material(0, mat)
	chunk_width = width
	chunk_length = length
	chunk_height = randi_range(1, 3)
	#chunk_height = 1
	position.x = x
	position.z = z
	scale = Vector3(chunk_width, chunk_height, chunk_length)
	mat.uv1_scale = Vector3(chunk_width+chunk_height, chunk_length, 1) / 4
	
	#mat.albedo_color = Color(randf(), randf() ,randf()) # debug

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
