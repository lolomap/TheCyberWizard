extends Node2D

@export var robot: Dude;
@export var flamethrower: Flamethrower;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flamethrower.IsEnabled = robot.anim.animation == "attack";
	if robot.target != null:
		flamethrower.look_at(robot.target.global_position)
