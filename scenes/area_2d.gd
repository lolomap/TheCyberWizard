extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_hit);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_hit(area):
	if area == G.Player:
		get_tree().root.get_node("Level1/CanvasLayer/Win").visible = true;
