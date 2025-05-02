using System;
using System.Collections.Generic;
using Godot;

namespace TheCyberWizard.core.gfx;

public static class GfxDefines
{
	/*
░█████╗░░█████╗░███╗░░░███╗███████╗██████╗░░█████╗░
██╔══██╗██╔══██╗████╗░████║██╔════╝██╔══██╗██╔══██╗
██║░░╚═╝███████║██╔████╔██║█████╗░░██████╔╝███████║
██║░░██╗██╔══██║██║╚██╔╝██║██╔══╝░░██╔══██╗██╔══██║
╚█████╔╝██║░░██║██║░╚═╝░██║███████╗██║░░██║██║░░██║
░╚════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝
 */
	#region
	public const int CAMERA_MOOVE_SPEED = 200;
	public const float CAMERA_ZOOM_SPEED = 0.2f;
	public const float CAMERA_ZOOM_MIN = 0.5f;
	public const float CAMERA_ZOOM_MAX = 5.0f;
	#endregion
	
	 /*
         
░██████╗░███████╗██╗░░██╗
██╔════╝░██╔════╝╚██╗██╔╝
██║░░██╗░█████╗░░░╚███╔╝░
██║░░╚██╗██╔══╝░░░██╔██╗░
╚██████╔╝██║░░░░░██╔╝╚██╗
░╚═════╝░╚═╝░░░░░╚═╝░░╚═╝
         */
        #region
        
        public enum Direction
        {
	        Up,
	        Right,
	        Down,
	        Left
        }

        public static readonly StringName[][] GFX_ANIMATIONS_UNIT =
        {
	        new StringName[] {"idle", "idle", "idle", "idle"},
	        new StringName[] { "walk_back", "walk_left", "walk_front", "walk_left"},
            new StringName[] { "death", "death", "death", "death" },
            new StringName[] { "attack", "attack", "attack", "attack" }
        };
        #endregion
}