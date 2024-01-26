
using Godot;
using System;
using System.Collections.Generic;

[Tool]
public partial class item_path : Path3D
{
	
	private PackedScene instancePackedScene;
	
	private String _file_path = "";
	private float _distance = 20;
	private Boolean _build = false;
	
	private List<Node3D> listOfNodes = new List<Node3D>(); 
	
	private PathFollow3D followPath;
	
	[Export] Boolean Build
	{
		get => false;
		set
		{
			// This is ran every time Build is updated.
			//Update when building
			GD.Print("huh?");
			spawnNodes();
		}
	}
	
	[Export]
	public float distance
	{
		get => _distance;
		set
		{
			// This is ran every time distance is updated.
			if(value<=0){
				_distance = 0.1f;
			}else{
				_distance = value;
				//distance = _distance;
			}
	
		}
	}
	
	[Export(PropertyHint.File)] public String file_path{
		get => _file_path;
		set
		{
			_file_path = value;
			instancePackedScene = (PackedScene)ResourceLoader.Load(_file_path);
			//file_path = _file_path;
		}
	}
	
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print(instancePackedScene);
		followPath = GetNode<PathFollow3D>("PathFollow3D");
		//spawnNodes();
	}
	

	public void spawnNodes(){
		GD.Print("built path");
		
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

		
	}
	
	public Node3D addNode(Vector3 position){
		Node3D newNode = (Node3D)instancePackedScene.Instantiate();
		AddChild(newNode);
		newNode.Position = position;
		listOfNodes.Add(newNode);
		GD.Print("node added");
		return newNode;
	}
	
	

}


