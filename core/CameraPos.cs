using Godot;
using TheCyberWizard.core.gfx;

//using static Defines not working here (idk why)

namespace TheCyberWizard.core;

public partial class CameraPos : Node2D
{
    private int MoveSpeed { get; set; } = GfxDefines.CAMERA_MOOVE_SPEED;
    private float ZoomSpeed { get; set; } = GfxDefines.CAMERA_ZOOM_SPEED;
    private Vector2 ZoomBounds { get; set; } = new(GfxDefines.CAMERA_ZOOM_MIN, GfxDefines.CAMERA_ZOOM_MAX);

    private Vector2 _velocity;

    private void GetInput()
    {
        /*if (!Utilities.Focus.HasFocus())
            return;*/

        Vector2 currentZoom = (Vector2)Utilities.Camera.Get("zoom");

        /*if (Input.IsActionJustReleased("zoom_up"))
        {
            currentZoom.X += ZoomSpeed;
            currentZoom.Y += ZoomSpeed;
            if (currentZoom.X < ZoomBounds.Y)
                Utilities.Camera.Set("zoom", currentZoom);
        }
        else if (Input.IsActionJustReleased("zoom_down"))
        {
            currentZoom.X -= ZoomSpeed;
            currentZoom.Y -= ZoomSpeed;
            if (currentZoom.X > ZoomBounds.X)
                Utilities.Camera.Set("zoom", currentZoom);
        }*/

        if (Input.IsMouseButtonPressed(MouseButton.Middle))
        {
            _velocity = -Input.GetLastMouseVelocity() / currentZoom.X;
        }
        else
        {
            Vector2 inputDirection = Input.GetVector("movement_left", "movement_right", "movement_up", "movement_down");
            _velocity = inputDirection * (MoveSpeed / currentZoom.X);
        }
    }

    public override void _Process(double delta)
    {
        GetInput();

        GlobalPosition += _velocity * (float)delta;
        //MoveAndSlide();
    }
}