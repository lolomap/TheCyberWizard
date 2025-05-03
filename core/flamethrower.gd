extends Node2D
class_name Flamethrower;


@export var IsEnabled: bool = true;
@export var ThrowerRoot: Node2D;
@export var DefaultDirection: Vector2;
@export var Fireball: PackedScene;
@export var speed = 50;

var Muzzle: Marker2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	Muzzle = $Muzzle;


func _on_animated_sprite_2d_animation_looped():
	if (!IsEnabled):
		return;
	var ball: RigidBody2D = Fireball.instantiate();
	ThrowerRoot.get_parent().add_child(ball);
	ball.global_transform = Muzzle.global_transform;
	var direction = DefaultDirection.rotated(rotation);
	ball.apply_impulse(direction * speed);
