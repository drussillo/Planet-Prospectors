extends Node3D

const GRAVITY = 9.8
const CHUNK_SMALL_SIZE = 16 # at least 2 for some reason
const CHUNK_BIG_SIZE = 64
const CHUNK_BIG_AMOUNT = 5
const PLANET_SIZE = 2 * CHUNK_BIG_SIZE * CHUNK_BIG_AMOUNT

const CHUNK_SCENE = preload("res://scenes/planet1/chunk.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PhysicsServer3D.area_set_param(
		get_viewport().find_world_3d().space, 
		PhysicsServer3D.AREA_PARAM_GRAVITY, 
		GRAVITY
	)
	
	# recursive chunk gen
	for z in range(CHUNK_BIG_AMOUNT):
		for x in range(CHUNK_BIG_AMOUNT):
			_generate_chunks(
				2 * x * CHUNK_BIG_SIZE + CHUNK_BIG_SIZE - PLANET_SIZE/2,
				2 * z * CHUNK_BIG_SIZE + CHUNK_BIG_SIZE - PLANET_SIZE/2,
				CHUNK_BIG_SIZE,
				CHUNK_BIG_SIZE
			)


func _generate_chunks(pos_x, pos_z, width, length) -> void:
	var vert_split_chance = 50
	var hor_split_chance = 50
	
	var vert_split = vert_split_chance >= rng.randi_range(1, 100)
	var hor_split = hor_split_chance >= rng.randi_range(1, 100)

	if !vert_split && !hor_split || width < CHUNK_SMALL_SIZE || length < CHUNK_SMALL_SIZE:
		print("no split")
		var chunk_instance = CHUNK_SCENE.instantiate()
		chunk_instance.set_chunk(pos_x, pos_z, width, length)
		add_child(chunk_instance)
		return

	if vert_split && hor_split:
		_generate_chunks(pos_x - width/2, pos_z - length/2, width/2, length/2)
		_generate_chunks(pos_x + width/2, pos_z - length/2, width/2, length/2)
		_generate_chunks(pos_x - width/2, pos_z + length/2, width/2, length/2)
		_generate_chunks(pos_x + width/2, pos_z + length/2, width/2, length/2)
	if vert_split && !hor_split:
		_generate_chunks(pos_x - width/2, pos_z, width/2, length)
		_generate_chunks(pos_x + width/2, pos_z, width/2, length)
	if !vert_split && hor_split:
		_generate_chunks(pos_x, pos_z + length/2, width, length/2)
		_generate_chunks(pos_x, pos_z - length/2, width, length/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
