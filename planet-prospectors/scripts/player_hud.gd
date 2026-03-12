extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func update_oilcount(current, objective) -> void:
	$oilcount.text = str("OIL: ", current, " / ", objective)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
