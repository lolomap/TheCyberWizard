extends StaticBody2D

@export var Fireball: PackedScene;
@export var speed = 50;

var Muzzle: Marker2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	Muzzle = $Muzzle;


func _on_animated_sprite_2d_animation_looped():
	var ball: RigidBody2D = Fireball.instantiate();
	get_parent().add_child(ball);
	ball.global_transform = Muzzle.global_transform;
	var direction = Vector2.DOWN.rotated(rotation);
	ball.apply_impulse(direction * speed);
