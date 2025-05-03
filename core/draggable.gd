extends RigidBody2D;
class_name Draggable;

@export var draggable_type = 2;
@export var kill_speed = 10;

const drag_force = 20;
const rotate_back_speed = 10;

var direction;

var selected = false;
var health: HealthComponent;

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_collision);
	#if (has_node("InteractableArea")):
	#	$InteractableArea.area_entered.connect(_on_collision_area);
	if (has_node("Health")):
		health = $Health;
		health.Dead.connect(func(): queue_free());


func _physics_process(delta):
	if selected:
		G.Player.Stamina -= G.Player.ControlStamina * linear_velocity.length() * delta;
		apply_force(Input.get_last_mouse_velocity() * drag_force * delta);
		#global_position = lerp(global_position, get_global_mouse_position(), drag_speed * delta);


func _on_interactable_area_input(viewport, event, shape_idx):
	if G.Player.Manipulation == 0 && G.Player.Entity == draggable_type && Input.is_action_just_pressed("Click"):
		G.Player.IsStaminaRestoring = false;
		selected = true;
		
func _input(event):
	direction = get_global_mouse_position();
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			G.Player.IsStaminaRestoring = true;
			selected = false;

func _on_collision(body: Node):
#	_on_collision_area(body);
	
#func _on_collision_area(area):
	if health != null:
		if body.is_in_group("Projectile") and health.IsFlamable:
			health.is_flaming = true;
	
	if linear_velocity.length() <= kill_speed: return;
	if !body.has_node("Health"):
		return;
	
	var h: HealthComponent = body.get_node("Health");
	h.damage(linear_velocity.length() / kill_speed);
	
	if health != null:
		health.damage(linear_velocity.length() / kill_speed / 1.5);
