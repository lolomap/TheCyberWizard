extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	G.Tilemap = self;
