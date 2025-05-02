extends Area2D

var parent: Draggable;
var is_touched = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_touched:
		return;
	if parent.selected:
		is_touched = true;
		parent.linear_velocity = Vector2.ZERO;
		return;
	#parent.position += (transform.x + transform.y)* speed * delta;
	


func _on_body_entered(body):
	if body == parent:
		return;
	parent.queue_free();
