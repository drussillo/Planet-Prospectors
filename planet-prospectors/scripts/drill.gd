extends Node3D

var velocityY = 0
var velocityR = 0

var chunk
var started

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var from = global_position + Vector3.UP * 100
	var to = global_position + Vector3.DOWN * 100
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result:
		global_position.y = result.position.y
	
	started = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !started:
		velocityR = 20 * delta
		started = true
	
	if chunk.oil_amount <= 0 && velocityR > 0:
		velocityR /= 1.025
	
	rotation.y += velocityR
	position.y += velocityY
