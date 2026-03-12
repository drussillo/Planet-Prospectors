extends Node3D

var chunk

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var from = global_position + Vector3.UP * 100
	var to = global_position + Vector3.DOWN * 100

	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result:
		global_position.y = result.position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
