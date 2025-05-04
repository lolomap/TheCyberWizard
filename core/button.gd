extends Area2D

@export var does_enable: bool;
@export var give_id: int = -1;
@export var disable_this_object: Node2D;
var off: Sprite2D;

signal door_connection(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	off = $Off;
	body_entered.connect(on_hit);
	body_exited.connect(on_exit);
	call_deferred("_on_start");
	
func _on_start():
	door_connection.emit(does_enable);
	
func on_hit(area):
	door_connection.emit(!does_enable);
	
	if give_id >= 0 and area != G.Player:
		return;
	if disable_this_object != null:
		disable_this_object.visible = false;
	
	if give_id == 0:
		G.Player.CanFire = true;
	elif give_id == 1:
		G.Player.CanWater = true;
	elif give_id == 2:
		G.Player.CanMind = true;
	elif give_id == 3:
		G.Player.CanCreate = true;
	elif give_id == 4:
		G.Player.Health.heal(1);
	elif give_id == 5:
		G.Player.Health.MaxHealth += 1;
		G.Player.Health.HealthChanged.emit();
		
	if give_id >= 0:
		queue_free();
		
	off.visible = false;

func on_exit(area):
	door_connection.emit(does_enable);
	off.visible = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
