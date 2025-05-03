using System;
using Godot;

namespace TheCyberWizard.core;

public partial class Player : CharacterBody2D
{
	public const float Speed = 300.0f;
	
	public int Health = 3;
	public bool IsDead = false;

	public enum Comnbination
	{
		Control,
		Create,
		Object,
		Fire,
		Water,
		Wind,
		Mind,
		None
	}

	public Comnbination Manipulation = Comnbination.None;
	public Comnbination Entity = Comnbination.None;

	[Export] public Node2D CastStream;
	[Export] public AnimatedSprite2D Animation;

	[Export] public CanvasItem CastStreamParticles;
	[Export] public Color CastStreamFireColor;
	[Export] public Color CastStreamWaterColor;

	[Signal]
	public delegate void UpdateHealthEventHandler(int health);

	public override void _Ready()
	{
		base._Ready();
		G.Instance.Player = this;
	}

	public override void _Process(double delta)
	{
		if (Velocity.Length() > 0)
		{
			if (Velocity.Normalized().X < 0)
				Animation.FlipH = false;
			else Animation.FlipH = true;
			Animation.Play("walk");
		}
		else
		{
			Animation.Play("idle");
		}
	}
	
	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity;

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 direction = Input.GetVector("movement_left", "movement_right", "movement_up", "movement_down");
		if (direction != Vector2.Zero)
		{
			velocity = direction.Normalized() * Speed * 10 * (float) delta;
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
			ToggleStream(false);
			
		}
		else if (@event.IsActionReleased("manipulate_create"))
		{
			Manipulation = Comnbination.Create;
		}
		else if (@event is InputEventKey eventKey && eventKey.IsReleased() && eventKey.Keycode is >= Key.Key1 and <= Key.Key5)
		{
			Entity = (Comnbination) (eventKey.Keycode - Key.Key1 + (long) Comnbination.Object);
			
			if (Manipulation != Comnbination.Create) return;
			switch (Entity)
			{
				case Comnbination.Fire:
					CastStreamParticles.Modulate = CastStreamFireColor;
					ToggleStream(true);
					break;
				case Comnbination.Water:
					CastStreamParticles.Modulate = CastStreamWaterColor;
					ToggleStream(true);
					break;
				case Comnbination.Wind:
					CastStreamParticles.Modulate = Colors.Gray;
					ToggleStream(true);
					break;
				default:
					ToggleStream(false);
					break;
			}
		}
	}

	private void ToggleStream(bool value)
	{
		CastStream.Visible = value;
		CastStream.GetNode<CollisionPolygon2D>("CastTrigger/CollisionShape2D").Disabled = !value;
	}

	public void OnHit(Area2D area)
	{
		Health--;
		EmitSignal(SignalName.UpdateHealth, Health);
		if (Health < 1)
		{
			IsDead = true;
		}
	}

	public void OnSpray(Node2D body)
	{
		switch (Entity)
		{
			case Comnbination.Fire:
			{
				if (!body.HasNode("Health")) break;

				Node bodyHealth = body.GetNode("Health");
				if ((bool) bodyHealth.Get("IsFlamable"))
				{
					bodyHealth.Set("is_flaming", true);
				}

				break;
			}
			case Comnbination.Water:
			{
				if (!body.HasNode("Health")) break;

				Node bodyHealth = body.GetNode("Health");
				if ((bool) bodyHealth.Get("IsElectronic"))
				{
					bodyHealth.Set("is_flaming", true);
				}
				
				break;
			}
		}
	}
	
	public void OnSprayArea(Area2D area)
	{
		if (area.Name != "Hitbox") return;
		Node2D body = area.GetParent<Node2D>();
		
		switch (Entity)
		{
			case Comnbination.Fire:
			{
				if (!body.HasNode("Health")) break;

				Node bodyHealth = body.GetNode("Health");
				if ((bool) bodyHealth.Get("IsFlamable"))
				{
					bodyHealth.Set("is_flaming", true);
				}

				break;
			}
			case Comnbination.Water:
			{
				if (!body.HasNode("Health")) break;

				Node bodyHealth = body.GetNode("Health");
				if ((bool) bodyHealth.Get("IsElectronic"))
				{
					bodyHealth.Set("is_flaming", true);
				}
				
				break;
			}
		}
	}
}