extends RigidBody2D;
class_name Draggable;

@export var draggable_type = 2;

const drag_force = 0.5;
const rotate_back_speed = 10;

var direction;

var selected = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if selected:
		apply_force(Input.get_last_mouse_velocity() * drag_force);
		#global_position = lerp(global_position, get_global_mouse_position(), drag_speed * delta);
		


func _on_interactable_area_input(viewport, event, shape_idx):
	if G.Player.Manipulation == 0 && G.Player.Entity == draggable_type && Input.is_action_just_pressed("Click"):
		selected = true;
		
func _input(event):
	direction = get_global_mouse_position();
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false;
