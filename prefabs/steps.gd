extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().IsWalking.connect(on_walking);

func on_walking(value):
	if value and !playing:
		play()
	if !value:
		stop();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
