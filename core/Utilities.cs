using System;
using Godot;

namespace TheCyberWizard.core
{
    //This is deprecated class and should be reorganized in the future
    public partial class Utilities : Node
    {
        public class Queue<T> : System.Collections.Generic.Queue<T>
        {
            public T LastElement {get; private set;}

            public new void Enqueue(T item)
            {
                LastElement = item;
                base.Enqueue(item);
            }
        }

        public static Utilities Self { get; private set; }
        public static Node Console { get; private set; }

        public static Random Rand { get; set; } = new();
        public static Random LocalRand { get; private set; } = new();

        public static Control Focus { get; private set; }
        public static GodotObject Camera { get; private set; }
        public static Node2D CamPos { get; private set; }
        public static TileMap Tilemap { get; private set; }

        public static Node EntitiesContainer { get; private set; }
        public static Node PropsContainer { get; private set; }
        public static Node TempContainer { get; private set; }

        public override void _Ready()
        {
            base._Ready();
            Self = this;

            /*
            Console = GetNode("../../Console");

            Focus = GetNode<Control>("../MapFocus");*/
            Camera = GetNode("../PhantomCamera2D");
            CamPos = GetNode<Node2D>("../CameraPosition");

            /*PropsContainer = GetNode("../Props");
            EntitiesContainer = GetNode("../Entities");
            TempContainer = GetNode("../Temp");*/

            Tilemap = GetNode<TileMap>("../Tilemap");
        }
        
    }
}
