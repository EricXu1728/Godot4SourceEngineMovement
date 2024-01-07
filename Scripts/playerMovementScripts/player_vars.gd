extends Resource
class_name playerVariables
#STORES VARIABLES TO BE USED BY ALL PLAYER PARTS
#Also stores very commonly used functions (such as friction) by most player related interfaces and parts

# Vectors
@export var vel = Vector3.ZERO
@export var snap = Vector3.DOWN



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

@export var ply_accelerate = 7 #ground accerleration
@export var ply_airaccelerate = 400 #effects control and surfing
@export var ply_maxacceleration = 10
@export var ply_airspeedcap = 1
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

# Bools
@export var noclip = false
@export var crouching : bool
@export var crouched : bool
@export var sprinting : bool
@export var canJump : bool
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
