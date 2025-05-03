extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("init");	

func init():
	max_value = G.Player.MaxStamina;
	value = G.Player.Stamina;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = G.Player.Stamina;
