extends Area2D

@export var does_enable: bool;
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
	off.visible = false;

func on_exit(area):
	door_connection.emit(does_enable);
	off.visible = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
