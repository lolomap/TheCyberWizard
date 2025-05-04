extends Node
class_name HealthComponent;

@export var MaxHealth: float;
@export var Health: float = -1;
@export var IsFlamable: bool;
@export var IsElectronic: bool;
@export var FlamingColor: Color;
@export var ElectronicColor: Color;
@export var FlamingPeriodSec: float = 0.5;
@export var IsDead: bool;

var fire_vfx: GPUParticles2D;
var parent: Node2D;

var __is_flaming: bool;
var is_flaming: bool = false : set = setFlaming, get = getFlaming;
func setFlaming(value):
	if __is_flaming == value:
		return;
	__is_flaming = value;
	fire_vfx.visible = value;
	if (value):
		flaming_timer.start();
	else:
		flaming_timer.stop();
func getFlaming():
	return __is_flaming;

signal Dead;
signal HealthChanged();

var flaming_timer: Timer;
var tint_timer: Timer;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent();
	fire_vfx = $FlameParticles;
	if (IsElectronic):
		fire_vfx.modulate = ElectronicColor;
	else:
		fire_vfx.modulate = FlamingColor;
	
	flaming_timer = Timer.new();
	flaming_timer.wait_time = FlamingPeriodSec;
	flaming_timer.timeout.connect(func(): damage(1));
	add_child(flaming_timer);
	
	tint_timer = Timer.new();
	tint_timer.wait_time = 0.5;
	tint_timer.timeout.connect(func(): parent.modulate = Color.WHITE);
	tint_timer.one_shot = true;
	add_child(tint_timer);
	
	if Health < 0:
		Health = MaxHealth;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func damage(value: float):
	if IsDead: return;
	
	Health -= value;
	HealthChanged.emit();
	
	parent.modulate = Color.FIREBRICK;
	tint_timer.start();
	
	if (Health <= 0):
		is_flaming = false;
		Health = 0;
		call_deferred("on_dead");

func on_dead():
	IsDead = true;
	Dead.emit();
