extends Node2D

@export var explosion : PackedScene;

var cursor = load("res://assets/textures/cursor_1.png");
var cursor_grab = load("res://assets/textures/cursor_2.png");

signal explosion_ready(emitter)

func _ready() -> void:
	G.Manager = self;
	Input.set_custom_mouse_cursor(cursor)
	
func set_cursor(grab: bool):
	if grab:
		Input.set_custom_mouse_cursor(cursor_grab, Input.CURSOR_DRAG);
	else:
		Input.set_custom_mouse_cursor(cursor)

func on_explosion(emitter: Node2D, area: Rect2):
	var e: AnimatedSprite2D = explosion.instantiate();
	e.global_position = area.position;
	var dimensions: Vector2 = e.sprite_frames.get_frame_texture("default", 0).get_size();
	var scale = area.size.y * 2 / dimensions.y;
	e.global_scale = Vector2(scale, scale);
	e.animation_finished.connect(e.queue_free);
	e.frame_changed.connect(on_exposion_ready.bind(e, emitter));
	add_child(e);

func on_exposion_ready(e: AnimatedSprite2D, emitter):
	if e.frame == 3:
		explosion_ready.emit(emitter);
		
