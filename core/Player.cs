using Godot;

namespace TheCyberWizard.core;

public partial class Player : CharacterBody2D
{
	public const float Speed = 60.0f;

	public enum Comnbination
	{
		Control,
		Create,
		Object,
		Fire,
		Water,
		Wind,
		Mind
	}

	public Comnbination Manipulation;
	public Comnbination Entity;

	public override void _Ready()
	{
		base._Ready();
		G.Instance.Player = this;
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 direction = Input.GetVector("movement_left", "movement_right", "movement_up", "movement_down");
		if (direction != Vector2.Zero)
		{
			velocity = direction * Speed;
		}
		else
		{
			velocity = Vector2.Zero;
		}

		Velocity = velocity;
		MoveAndSlide();
	}

	public override void _Input(InputEvent @event)
	{
		base._Input(@event);

		// Handle combinations
		if (@event.IsActionReleased("manipulate_control"))
		{
			Manipulation = Comnbination.Control;
		}
		else if (@event.IsActionReleased("manipulate_create"))
		{
			Manipulation = Comnbination.Create;
		}
		else if (@event is InputEventKey eventKey && eventKey.IsReleased() && eventKey.Keycode is >= Key.Key1 and <= Key.Key5)
		{
			Entity = (Comnbination) (eventKey.Keycode - Key.Key1 + (long) Comnbination.Object);
		}
	}
}