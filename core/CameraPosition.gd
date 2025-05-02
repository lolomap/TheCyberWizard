extends Node2D

var player: CharacterBody2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	player = G.Player;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = player.global_position;
