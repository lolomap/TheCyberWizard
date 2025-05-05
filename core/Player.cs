using System;
using Godot;

namespace TheCyberWizard.core;

public partial class Player : CharacterBody2D
{
	public const float Speed = 400.0f;

	[Export] public float MaxStamina = 100;
	[Export] public float CreateStamina = 10;
	[Export] public float ControlStamina = 3;
	[Export] public float RestoreStamina = 15;
	[Export] public bool CanCastOnMovement;

	public Node2D Health;
	public float Stamina;
	public bool IsStaminaRestoring = true;
	
	public bool IsControl;
	public bool IsCreate;
	public bool IsObject;
	public bool IsFire;
	public bool IsWater;
	public bool IsMind;


	[Export] public bool CanControl;
	[Export] public bool CanCreate;
	[Export] public bool CanObject;
	[Export] public bool CanFire;
	[Export] public bool CanWater;
	[Export] public bool CanMind;

	public enum Comnbination
	{
		Control,
		Create,
		Object,
		Fire,
		Water,
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

	[Signal]
	public delegate void IsWalkingEventHandler(bool value);
    
	public override void _Ready()
	{
		base._Ready();
		Stamina = MaxStamina;
		G.Instance.Player = this;
		Health = GetNode<Node2D>("Health");
		
		IsControl = true;
		Manipulation = Comnbination.Control;
		Entity = Comnbination.Object;
		IsObject = true;
	}

	public void ResetAspect()
	{
		IsObject = false;
		IsFire = false;
		IsWater = false;
		IsMind = false;
	}
	
	public void ResetCombination()
	{
		ToggleStream(false);
		Manipulation = Comnbination.None;
		Entity = Comnbination.None;

		IsControl = false;
		IsCreate = false;
		ResetAspect();
		
		IsStaminaRestoring = true;
	}

	public override void _Process(double delta)
	{
		if (Stamina <= 0)
		{
			Stamina = 0;
			ResetCombination();
		}

		if (IsStaminaRestoring)
		{
			Stamina += RestoreStamina * (float) delta;
			if (Stamina > MaxStamina) Stamina = MaxStamina;
		}
		
		if (Velocity.Length() > 0)
		{
			if (Velocity.Normalized().X < 0)
				Animation.FlipH = false;
			else Animation.FlipH = true;
			Animation.Play("walk");
		}
		else if (!IsStaminaRestoring)
		{
			Animation.Play("cast");
		}
		else
		{
			Animation.Play("idle");
		}
	}

	
	
	public override void _PhysicsProcess(double delta)
	{
		Vector2 tile = G.Instance.Tilemap.GetCellAtlasCoords(G.Instance.Tilemap.LocalToMap(Position));
		if (tile is {X: 0, Y: 2})
		{
			Health.Call("damage", Health.Get("MaxHealth"));
			
			return;
		}
		
		Vector2 velocity;

		Vector2 direction = Input.GetVector("movement_left", "movement_right", "movement_up", "movement_down");
		if (direction != Vector2.Zero && (CanCastOnMovement || IsStaminaRestoring))
		{
			velocity = direction.Normalized() * Speed * 10 * (float) delta;
			EmitSignal(SignalName.IsWalking, true);
		}
		else
		{
			velocity = Vector2.Zero;
			EmitSignal(SignalName.IsWalking, false);
		}

		Velocity = velocity;
		MoveAndSlide();
	}

	public override void _Input(InputEvent @event)
	{
		base._Input(@event);

		// Handle combinations
		if (CanControl && @event.IsActionReleased("manipulate_control"))
		{
			ResetCombination();
			IsControl = true;
			Manipulation = Comnbination.Control;
			
		}
		else if (CanCreate && @event.IsActionReleased("manipulate_create"))
		{
			ResetCombination();
			IsCreate = true;
			Manipulation = Comnbination.Create;
		}
		else if (@event is InputEventKey eventKey && eventKey.IsReleased() && eventKey.Keycode is >= Key.Key1 and <= Key.Key5)
		{
			ResetAspect();
			Entity = (Comnbination) (eventKey.Keycode - Key.Key1 + (long) Comnbination.Object);
			switch (Entity)
			{
				case Comnbination.Fire:
					if (!CanFire) Entity = Comnbination.None;
					IsFire = true;
					break;
				case Comnbination.Object:
					if (!CanObject) Entity = Comnbination.None;
					IsObject = true;
					break;
				case Comnbination.Water:
					if (!CanWater) Entity = Comnbination.None;
					IsWater = true;
					break;
				case Comnbination.Mind:
					if (!CanMind) Entity = Comnbination.None;
					IsMind = true;
					break;
			}
			
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
				default:
					ToggleStream(false);
					break;
			}
		}
	}

	private void ToggleStream(bool value)
	{
		IsStaminaRestoring = !value;
		CastStream.Visible = value;
		CastStream.GetNode<CollisionPolygon2D>("CastTrigger/CollisionShape2D").Disabled = !value;
	}

	public void Dead()
	{
		GetTree().ReloadCurrentScene();
	}

	public void OnHit(Area2D area)
	{
		Health.Call("damage", 1);
	}

	public void OnSpray(Node2D body)
	{
		switch (Entity)
		{
			case Comnbination.Fire:
			{
				if (!body.HasNode("Health")) break;

				Node bodyHealth = body.GetNode("Health");
				bool isFlamable = (bool) bodyHealth.Get("IsFlamable");
				bool isElectronic = (bool) bodyHealth.Get("IsElectronic");
				bool isFlaming = (bool) bodyHealth.Get("is_flaming");
				
				if (isFlamable)
				{
					bodyHealth.Set("is_flaming", true);
				}
				else if (isFlaming)
				{
					bodyHealth.Set("is_flaming", false);
				}

				break;
			}
			case Comnbination.Water:
			{
				if (!body.HasNode("Health")) break;

				Node bodyHealth = body.GetNode("Health");
				bool isFlamable = (bool) bodyHealth.Get("IsFlamable");
				bool isElectronic = (bool) bodyHealth.Get("IsElectronic");
				bool isFlaming = (bool) bodyHealth.Get("is_flaming");
                
				if (isElectronic)
				{
					bodyHealth.Set("is_flaming", true);
				}
				else if (isFlaming)
				{
					bodyHealth.Set("is_flaming", false);
				}
				
				break;
			}
		}
	}
	
	public void OnSprayArea(Area2D area)
	{
		if (area.Name != "Hitbox") return;
		Node2D body = area.GetParent<Node2D>();
		OnSpray(body);
	}
}