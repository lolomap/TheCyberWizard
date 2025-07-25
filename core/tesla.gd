extends StaticBody2D

var health: HealthComponent;
var trigger: Area2D;
var killzone: Area2D;
var killzone_shape: CircleShape2D;
@export var does_enable: bool;

signal door_connection(value)
signal generator_connection(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = $Health;
	trigger = $Area2D;
	killzone = $KillZone;
	killzone_shape = $KillZone/CollisionShape2D.shape;
	health.Dead.connect(_on_dead);
	trigger.area_entered.connect(on_hit);
	killzone.area_entered.connect(on_spray);
	
	call_deferred("_on_start");
	
func _on_start():
	door_connection.emit(!does_enable);

var is_dying;
func on_dead_ready(emitter):
	if emitter == self:
		queue_free();
	queue_free()
func _on_dead():
	door_connection.emit(does_enable);
	generator_connection.emit(false);
	
	if is_dying: return
	is_dying = true;
	
	G.Manager.explosion_ready.connect(on_dead_ready);
	var size = $Area2D/CollisionShape2D.shape.size;
	G.Manager.on_explosion(self, Rect2(global_position, size));

func on_hit(area: Area2D):
	health.is_flaming = true;
	
func on_spray(area: Area2D):
	if area.get_parent().visible and G.Player.Entity == 4:
		G.Player.Health.damage(G.Player.Health.MaxHealth);
