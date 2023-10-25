extends CharacterBody3D
#STORES VARIABLES TO BE USED BY ALL PLAYER PARTS
#Also stores very commonly used functions (such as friction) by most player related interfaces and parts

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

var ply_accelerate = 3 #ground accerleration
var ply_airaccelerate = 2 #Turn up for faster air straifing and control
var ply_maxacceleration = 30
var ply_airspeedcap = 10
var ply_friction = 1
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

var camera : Node3D

#funcs
func Friction(delta):
	# If we are in water jump cycle, don't apply friction
	#if (player->m_flWaterJumpTime)
	#	return

	# Calculate speed
	var speed = vel.length()
	
	# If too slow, return
	if speed < 0:
		return

	var drop = 0

	# apply ground friction
	var friction = ply_friction

	# Bleed off some speed, but if we have less than the bleed
	#  threshold, bleed the threshold amount.
	var control = ply_stopspeed if speed < ply_stopspeed else speed
	# Add the amount to the drop amount.
	drop += control * friction * delta

	# scale the velocity
	var newspeed = speed - drop
	if newspeed < 0:
		newspeed = 0

	if newspeed != speed:
		# Determine proportion of old speed we are using.
		newspeed /= speed
		# Adjust velocity according to proportion.
		vel *= newspeed

func CheckVelocity():
	# bound velocity
	# Bound it.
	if vel.length() > ply_maxvelocity:
		vel = ply_maxvelocity
			
	elif vel.length() < -ply_maxvelocity:
		vel = -ply_maxvelocity


func _ready():
	assert("You should not be seeing this (player_vars.gd is being initiated)")
