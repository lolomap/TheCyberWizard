extends CharacterBody2D


@export var SPEED = 300.0
var direction;

var anim: AnimatedSprite2D;
var nav: NavigationAgent2D;

func _ready():
	set_physics_process(false)
	anim = $AnimatedSprite2D;
	nav = $NavigationAgent2D;
	call_deferred("actor_setup")
	
func actor_setup():
	await get_tree().physics_frame;
	
	set_physics_process(true)

func _process(delta: float) -> void:
	if velocity.length() > 0:
		anim.play("walk");

func _physics_process(delta):
	nav.target_position = G.Player.global_position;
	velocity = global_position.direction_to(nav.get_next_path_position()).normalized() * SPEED * 50 * delta;
	move_and_slide()
