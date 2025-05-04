extends HBoxContainer

@export var health_point_icon: PackedScene;

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred('init');
	
func init():
	G.Player.Health.HealthChanged.connect(set_health);
	for i in range(0, G.Player.Health.Health):
		var item: TextureRect = health_point_icon.instantiate();
		add_child(item);

func set_health():
	for item in get_children():
		item.queue_free();
	for i in range(0, G.Player.Health.Health):
		var item: TextureRect = health_point_icon.instantiate();
		add_child(item);
	for i in range(G.Player.Health.Health, G.Player.Health.MaxHealth):
		var item: TextureRect = health_point_icon.instantiate();
		item.modulate = Color8(255,255,255,50)
		add_child(item);
