extends Node3D

const GRAVITY = 9.8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, GRAVITY)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
