using Godot;
using System;
using static Godot.Mathf; 

namespace playerVariables{
	
	public partial class player_vars : Resource
	{

		

		//public float newvar = DegToRad((float) 45);
		
		//STORES intIABLES TO BE USED BY ALL PLAYER PARTS
		//Also stores very commonly used functions (such as friction) by most player related interfaces and parts Vectors
		[Export] public Vector3 vel {get; set;} = Vector3.Zero;
		[Export] public Vector3 lostSpeed {get; set;} = Vector3.Zero;
		[Export] public Vector3 snap {get; set;} = Vector3.Down;
		
		// Mouse stuff
		[Export] public float ply_mousesensitivity {get; set;} = 1.5f;
		[Export] public int ply_maxlookangle_down {get; set;} = -90;
		[Export] public int ply_maxlookangle_up {get; set;} = 90;
		[Export] public float ply_ylookspeed {get; set;} = 0.3f;
		[Export] public float ply_xlookspeed {get; set;} = 0.3f;
		[Export] public int ply_sidespeed {get; set;} = 20;
		[Export] public int ply_upspeed {get; set;} = 20;
		[Export] public int ply_forwardspeed {get; set;} = 20;
		[Export] public int ply_backspeed {get; set;} = 20;

		//Player vars
		[Export] public int ply_accelerate {get; set;} = 7; //ground acceleration
		[Export] public int ply_airaccelerate {get; set;} = 400; //effects control and surfing
		[Export] public  int ply_maxacceleration {get; set;} = 10;
		[Export] public  float ply_airspeedcap {get; set;} = 1.5f; //turn up for faster air straifing and surfing 
		[Export] public  float ply_climbspeedcap {get; set;} = 0f; 
		[Export] public  float ply_climbaccelerate {get; set;} = 0f; 
		[Export] public  int ply_friction {get; set;} = 3;
		[Export] public  int ply_stopspeed {get; set;} = 50;
		[Export] public  int ply_gravity {get; set;} = 60;

		[Export] public  float ply_maxslopeangle  {get; set;} = Mathf.DegToRad((float) 45);
		[Export] public  int ply_maxvelocity {get; set;} = 35000;
		
		[Export] public  int ply_jumpheight {get; set;} = 4;
		[Export] public  int ply_stepsize {get; set;} = 8;

		[Export] public int ply_maxspeed {get; set;} = 16;
		[Export] public int ply_crouchspeed {get; set;} = 10;
		public float speed = 0;

		//  bools
		[Export] public bool noclip {get; set;} = false;
		[Export] public bool crouching {get; set;}
		[Export] public bool crouched {get; set;}
		[Export] public bool sprinting {get; set;}
		[Export] public bool canJump {get; set;}
		public bool wasOnFloor  = false;
		public bool on_floor = false;
		public bool shouldJump = false;
		public bool collision = false;

		// Floats
		[Export] public float sidemove {get; set;}
		[Export] public float upmove {get; set;}
		[Export] public float forwardmove {get; set;}
		[Export] public float ylook {get; set;}
		[Export] public float xlook {get; set;}

		//Camera
		[Export] public Godot.NodePath camPath  {get; set;}

		

		float a = DegToRad((float)0.1);
	}
}
/*
extends Resource
class_name playerVariables
#STORES VARIABLES TO BE USED BY ALL PLAYER PARTS
#Also stores very commonly used functions (such as friction) by most player related interfaces and parts
# Vectors
@export var vel := Vector3.ZERO
@export var snap := Vector3.DOWN


# ConVars
@export var ply_mousesensitivity = 1.5
@export var ply_maxlookangle_down = -90
@export var ply_maxlookangle_up = 90
@export var ply_ylookspeed = 0.3
@export var ply_xlookspeed = 0.3
@export var ply_sidespeed = 20
@export var ply_upspeed = 20
@export var ply_forwardspeed = 20
@export var ply_backspeed = 20

@export var ply_accelerate = 10 #ground accerleration
@export var ply_airaccelerate = 12 #effects control and surfing
@export var ply_maxacceleration = 10
@export var ply_airspeedcap = 7 #turn up for faster air straifing and surfing 
@export var ply_friction = 3
@export var ply_stopspeed = 50
@export var ply_gravity = 60
@export var ply_maxslopeangle = deg_to_rad(45)
@export var ply_maxvelocity = 35000

@export var ply_jumpheight = 4#4
@export var ply_stepsize = 8

@export var ply_maxspeed = 16
@export var ply_crouchspeed = 10
var speed = ply_maxspeed

# public bools
@export var noclip = false
@export var crouching : public bool
@export var crouched : public bool
@export var sprinting : public bool
@export var canJump : public bool
@export var wasOnFloor = false
@export var on_floor = false
@export var shouldJump = false



# Floats
@export var sidemove : float
@export var upmove : float
@export var forwardmove : float
@export var ylook : float
@export var xlook : float

@export var camPath : NodePath


func _ready():
	push_warning("You should not be seeing this (player_vars.gd is being initiated)")
*/
