extends StaticBody2D

var __is_open;

@export var is_open: bool = false : set = setIsOpen, get = getIsOpen;

@export var animation: AnimatedSprite2D;
@export var collision: CollisionShape2D;

func getIsOpen():
	return __is_open;

func setIsOpen(value):
	__is_open = value;
	if (value):
		animation.play("default");
	else:
		animation.play_backwards("default");

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.animation_finished.connect(func(): collision.disabled = is_open);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
