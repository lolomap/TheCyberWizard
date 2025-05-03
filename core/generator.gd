extends RigidBody2D

var health: HealthComponent;
var trigger: Area2D;
@export var does_enable: bool;

signal door_connection(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = $Health;
	trigger = $Area2D;
	health.Dead.connect(_on_dead);
	trigger.area_entered.connect(on_hit);
	
	call_deferred("_on_start");
	
func _on_start():
	door_connection.emit(!does_enable);

func _on_dead():
	door_connection.emit(does_enable);
	queue_free()

func on_hit(area: Area2D):
	health.is_flaming = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
