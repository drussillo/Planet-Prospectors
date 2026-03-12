extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$planet1/player.oil_changed.connect($playerHUD.update_oilcount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
