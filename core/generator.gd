extends RigidBody2D

var health: HealthComponent;
var trigger: Area2D;
@export var does_enable: bool;
@export var connection: Node2D;

signal door_connection(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = $Health;
	trigger = $Area2D;
	if connection != null and connection.has_signal("generator_connection"):
		connection.generator_connection.connect(_on_disable)
	health.Dead.connect(_on_dead);
	trigger.area_entered.connect(on_hit);
	
	call_deferred("_on_start");

func _on_start():
	door_connection.emit(!does_enable);

var is_dying;
func on_dead_ready(emitter):
	if emitter == self:
		queue_free();
func _on_dead():
	_on_disable(false);
	
	if is_dying: return
	is_dying = true;
	
	G.Manager.explosion_ready.connect(on_dead_ready);
	var size = $Area2D/CollisionShape2D.shape.size;
	G.Manager.on_explosion(self, Rect2(global_position, size));
	
func _on_disable(value):
	if !value:
		door_connection.emit(does_enable);
		$AnimatedSprite2D.stop();
	else:
		door_connection.emit(!does_enable);
		$AnimatedSprite2D.play();

func on_hit(area: Area2D):
	health.is_flaming = true;
