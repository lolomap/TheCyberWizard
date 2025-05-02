extends HBoxContainer

@export var health_point_icon: PackedScene;

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred('init');
	
func init():
	G.Player.UpdateHealth.connect(set_health);
	for i in range(0, G.Player.Health):
		var item: TextureRect = health_point_icon.instantiate();
		add_child(item);

func set_health(health):
	for item in get_children():
		item.queue_free();
	for i in range(0, health):
		var item: TextureRect = health_point_icon.instantiate();
		add_child(item);
