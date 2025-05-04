extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var tint = Color8(255, 255, 255, 50)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Control.visible = G.Player.CanControl;
	$Create.visible = G.Player.CanCreate;
	
	if !G.Player.IsControl:
		$Control.modulate = tint;
	else:
		$Control.modulate = Color.WHITE;
	if !G.Player.IsCreate:
		$Create.modulate = tint;
	else:
		$Create.modulate = Color.WHITE;
