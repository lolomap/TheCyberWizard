extends Node2D

var particles: GPUParticles2D;
var castTrigger: Area2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	particles = $GPUParticles2D;
	castTrigger = $CastTrigger;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		G.Player.Stamina -= G.Player.CreateStamina * delta;
	
	castTrigger.look_at(get_global_mouse_position());
	var dir = particles.global_position.direction_to(get_global_mouse_position());
	(particles.process_material as ParticleProcessMaterial).direction = Vector3(dir.x, dir.y, 0);
