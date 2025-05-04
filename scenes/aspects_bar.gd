extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var tint = Color8(255, 255, 255, 50);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Object.visible = G.Player.CanControl and G.Player.IsControl;
	$Fire.visible = G.Player.CanFire;
	$Water.visible = G.Player.CanWater and G.Player.IsCreate;
	$Mind.visible = G.Player.CanMind  and G.Player.IsControl;

	if !G.Player.IsObject:
		$Object.modulate = tint;
	else:
		$Object.modulate = Color.WHITE;
		
	if !G.Player.IsFire:
		$Fire.modulate = tint;
	else:
		$Fire.modulate = Color.WHITE;
	
	if !G.Player.IsWater:
		$Water.modulate = tint;
	else:
		$Water.modulate = Color.WHITE;
		
	if !G.Player.IsMind:
		$Mind.modulate = tint;
	else:
		$Mind.modulate = Color.WHITE;
