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
			if (Velocity.Normalized() is {X: -1, Y: 0} || Velocity.Angle() >= Math.PI / 2 && Velocity.Angle() <= Math.PI || Velocity.Angle() <= -Math.PI / 2)
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
			CastStream.Visible = false;
		}
		else if (@event.IsActionReleased("manipulate_create"))
		{
			Manipulation = Comnbination.Create;
			CastStream.Visible = true;
		}
		else if (@event is InputEventKey eventKey && eventKey.IsReleased() && eventKey.Keycode is >= Key.Key1 and <= Key.Key5)
		{
			Entity = (Comnbination) (eventKey.Keycode - Key.Key1 + (long) Comnbination.Object);
			switch (Entity)
			{
				case Comnbination.Fire:
					CastStreamParticles.Modulate = CastStreamFireColor;
					break;
				case Comnbination.Water:
					CastStreamParticles.Modulate = CastStreamWaterColor;
					break;
			}
		}
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
}