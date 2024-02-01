
using Godot;
using System;
using System.Collections.Generic;

[Tool]
public partial class item_path : Path3D
{



	private Boolean _build = false;
	[Export] Boolean Build
	{
		get => false;
		set
		{
			// This is ran every time Build is updated.
			//Update when building
			if (Engine.IsEditorHint() && value == true){
				GD.Print("Building?");
				GD.Print(distance);
				spawnNodes();
			}else{
				GD.Print("doing nothing");
			}
		}
	}
	
	

	private PackedScene instancePackedScene;
	private String _file_path = "";
	[Export(PropertyHint.File)] public String file_path
	{
		get => _file_path;
		set
		{
			_file_path = value;
			instancePackedScene = (PackedScene)ResourceLoader.Load(_file_path);
		}
	}
	
	private float _distance = 20;
	[Export]
	public float distance

	{
		get => _distance;
		set
		{
			if (Engine.IsEditorHint()){
				// This is ran every time distance is updated.
				if(value<=0){
					_distance = 0.1f;
				}else{
					_distance = value;
					//distance = _distance;
				}
			}
		}
	}
	
	private List<Node3D> listOfNodes = new List<Node3D>(); 
	
	private PathFollow3D followPath;

	public override void _Ready()
	{
		
		followPath = GetNode<PathFollow3D>("PathFollow3D");
		GD.Print(file_path);
		spawnNodes();
	}
	
	public Node3D addNode(Vector3 position){
		Node3D newNode = (Node3D)instancePackedScene.Instantiate();
		AddChild(newNode);
		newNode.Position = position;
		listOfNodes.Add(newNode);
		GD.Print("node added");
		return newNode;
	}
	
	public void spawnNodes(){
		foreach(Node3D n in listOfNodes){
			n.QueueFree();
		}
		listOfNodes.Clear();
		
		float length = this.Curve.GetBakedLength();

		float progress = 0;

		while(progress <length){
			progress +=distance;
			followPath.Progress = progress;
			
			Vector3 position_to_spawn = followPath.Position;
			addNode(position_to_spawn);
			
		}
		GD.Print("Built");
	}
	
}


