extends TileMap

func _ready():
	call_deferred("set_navigation")

func set_navigation():
	NavigationServer2D.map_set_cell_size(get_navigation_map(0), 1);
