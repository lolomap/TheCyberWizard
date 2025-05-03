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

var flaming_timer: Timer;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fire_vfx = $FlameParticles;
	if (IsElectronic):
		fire_vfx.modulate = ElectronicColor;
	else:
		fire_vfx.modulate = FlamingColor;
	
	Dead.connect(die);
	
	flaming_timer = Timer.new();
	flaming_timer.wait_time = FlamingPeriodSec;
	flaming_timer.timeout.connect(func(): damage(1));
	add_child(flaming_timer);
	if Health < 0:
		Health = MaxHealth;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func damage(value: float):
	Health -= value;
	if (Health <= 0):
		is_flaming = false;
		Health = 0;
		Dead.emit();

func die():
	get_parent().queue_free();
