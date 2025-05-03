extends StaticBody2D

var s_is_open = false;

@export var is_open: bool = false : set = setIsOpen, get = getIsOpen;
@export var connection: Node2D;

@export var animation: AnimatedSprite2D;
@export var collision: CollisionShape2D;

func getIsOpen():
	return s_is_open;

func setIsOpen(value):
	s_is_open = value;
	if (value):
		animation.play("default");
	else:
		animation.play_backwards("default");

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.animation_finished.connect(func(): collision.disabled = s_is_open);
	if connection != null and connection.has_signal("door_connection"):
		connection.door_connection.connect(setIsOpen);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
