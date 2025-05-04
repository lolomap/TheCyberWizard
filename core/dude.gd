extends CharacterBody2D
class_name Dude;

@export var SPEED = 300.0
@export var ATACK_RANGE = 10;
@export var ALLOW_DIRECT_ATACK = true;
var direction;
var is_attacking: bool;

var anim: AnimatedSprite2D;
var nav: NavigationAgent2D;
var health: HealthComponent;
var hitbox: Area2D;
var target: Node2D;
var is_dying: bool;
var is_pot: bool;

func _ready():
	set_physics_process(false)
	anim = $AnimatedSprite2D;
	nav = $NavigationAgent2D;
	health = $Health;
	hitbox = $Hitbox;
	target = G.Player;
	
	health.Dead.connect(dead);
	nav.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed);
	hitbox.area_entered.connect(on_hit);
	anim.animation_looped.connect(direct_attack);
	call_deferred("actor_setup")

func dead():
	if is_dying: return
	is_dying = true;
	
	velocity = Vector2.ZERO;
	nav.velocity = Vector2.ZERO;
	
	if health.IsElectronic:
		G.Manager.explosion_ready.connect(on_dead_ready);
		var size = anim.sprite_frames.get_frame_texture("idle", 0).get_size();
		G.Manager.on_explosion(self, Rect2(global_position, size));
	else:
		anim.play("die");
		if is_pot:
			anim.animation_finished.connect(queue_free);

func on_dead_ready(emitter):
	if emitter == self:
		queue_free();

func direct_attack():
	if ALLOW_DIRECT_ATACK and is_attacking:
		target.get_node("Health").damage(1);
		is_attacking = false;
	
func actor_setup():
	await get_tree().physics_frame;
	
	set_physics_process(true)

func _process(delta: float) -> void:
	if health.IsDead:
		if is_pot:
			scale -= Vector2.ONE * delta;
		return;
	
	var tile = G.Tilemap.get_cell_atlas_coords(G.Tilemap.local_to_map(position));
	if tile.x == 0 and tile.y == 2:
		is_pot = true;
		position = G.Tilemap.map_to_local(G.Tilemap.local_to_map(position));
		health.damage(health.MaxHealth);
	
	if is_attacking: return;
	
	if global_position.distance_to(target.global_position) <= ATACK_RANGE:
		is_attacking = true;
		anim.play("attack");
		return;
	
	if velocity.length() > 0:
		anim.play("walk");
	else:
		anim.play("idle");
		
	if velocity.normalized().x < 0:
		anim.flip_h = false;
	else:
		anim.flip_h = true;

func _physics_process(delta):
	if health.IsDead: return;
	nav.target_position = target.global_position;
	var v = global_position.direction_to(nav.get_next_path_position()).normalized() * SPEED * 50 * delta;
	nav.velocity = v;
	

func on_hit(area: Area2D):
	if health.IsFlamable:
		health.is_flaming = true;

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if nav.is_navigation_finished() == false:
		velocity = safe_velocity;
		move_and_slide()
