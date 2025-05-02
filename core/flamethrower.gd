extends StaticBody2D

@export var Fireball: PackedScene;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animated_sprite_2d_animation_looped():
	var ball = Fireball.instantiate();
	get_parent().add_child(ball);
	ball.transform = $Muzzle.global_transform;
