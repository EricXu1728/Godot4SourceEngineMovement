using Godot;
using System;
using System.Collections.Generic;
[Tool]

public partial class interateNode : Node3D
{
	private Boolean _build = false;

	[Export] Vector3 itemSpread = Vector3.One;
	[Export] Vector3 itemSize = Vector3.One;
	[Export] Vector3 itemScale = Vector3.One;
	[Export] Boolean Build
	{
		get => false;
		set
		{
			// This is ran every time Build is updated.
			//Update when building
			if (Engine.IsEditorHint() && value != Build){
				GD.Print("Building?");
				//GD.Print(distance);
				spawnNodes();
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

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print(file_path);
		spawnNodes();
	}


	public void spawnNodes(){
		GD.Print("spawining");
		foreach(Node3D n in listOfNodes){
			n.QueueFree();
		}
		listOfNodes.Clear();

		for (int x = 0; x < itemSpread[0]; x++){
			for (int y = 0; y < itemSpread[1]; y++){
				for (int z = 0; z < itemSpread[2]; z++){
					addNode(new Vector3(x*itemSize[0], y * itemSize[1], z * itemSize[2]), itemScale);
				}
			}
		}
		
	}


	private List<Node3D> listOfNodes = new List<Node3D>(); 
	public Node3D addNode(Vector3 position, Vector3 scale){
		Node3D newNode = (Node3D)instancePackedScene.Instantiate();
		AddChild(newNode);
		newNode.Scale = scale;
		newNode.Position = position;
		listOfNodes.Add(newNode);
		GD.Print("node added");
		return newNode;
	}
}
