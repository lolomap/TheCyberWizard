using Godot;

namespace TheCyberWizard.core;

public partial class G : Node
{
	public static G Instance;
	
	public Player Player;
	public TileMapLayer Tilemap;

	public override void _Ready()
	{
		base._Ready();
		Instance = this;
	}
}