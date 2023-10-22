extends CharacterBody3D

# Vectors
var vel = Vector3.ZERO
var snap = Vector3.DOWN



# ConVars
var ply_mousesensitivity = 1.5
var ply_maxlookangle_down = -90
var ply_maxlookangle_up = 90
var ply_ylookspeed = 0.3
var ply_xlookspeed = 0.3
var ply_sidespeed = 20
var ply_upspeed = 20
var ply_forwardspeed = 20
var ply_backspeed = 20

var ply_accelerate = 5
var ply_airaccelerate = 5
var ply_maxacceleration = 50
var ply_airspeedcap = 10
var ply_friction = 2
var ply_stopspeed = 100
var ply_gravity = 50
var ply_maxslopeangle = deg_to_rad(45)
var ply_maxvelocity = 35000

var ply_jumpheight = 4#4
var ply_stepsize = 8

var ply_maxspeed = 15

# Bools
var noclip : bool
var crouching : bool
var crouched : bool
var sprinting : bool
var canJump : bool
var wasOnFloor = false


# Floats
var sidemove : float
var upmove : float
var forwardmove : float
var ylook : float
var xlook : float


