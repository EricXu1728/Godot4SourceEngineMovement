extends RichTextLabel

@export var stats : Resource
@export var player : Player
var stateMachine : StateMachine
var font
var stack = Array()
var startSpeed
var endSpeed
var speedVec
var speed = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	stateMachine = player.get_child(2)#hopefully gets statemachine
	stateMachine.connect("transitioned", method_name)
	font = FontFile.new()
	font.font_data = load("res://Helvetica Regular/Helvetica Regular.otf")
	show()

func _process(delta):
	
	
	speedVec = Vector2(stats.vel.x, stats.vel.z)
	speed = speedVec.length()
	var mestring  = str(speed)
	
	text = str(stats.shouldJump) + mestring + "\n" + str(Engine.get_frames_per_second() ) + "\n" + str(stats.vel.length()*delta)
	queue_redraw()

func _draw():
	
	draw_rect(Rect2(1, 70.0, speed*10, 5), Color.GREEN)
	draw_rect(Rect2(1, 100.0, stats.vel.length()*10, 5), Color.RED)
	draw_rect(Rect2(200, 120.0, 3000, 50), Color.BLACK)
	
	var count = 0
	for item in stack:
		var stackcount = stack.size()
		if(not stackcount==0):
			var step = float(1)/stackcount
			
			var mycolor = Color(step*count,step*count,1)
			if (count == stackcount-1):
				if(item>10):
					mycolor = Color.YELLOW
				else:
					mycolor = Color.RED
			draw_rect(Rect2(200+(item), 120, 25, 25), mycolor)
			count+=1
			
			


func method_name(nuhuh: String):
	if(nuhuh == "Air" && stats.wasOnFloor):
		startSpeed = speed
	if(nuhuh == "Run"):
		endSpeed = speed
		if ((not(startSpeed == null))&&(not(endSpeed == null)) && startSpeed>15):
			var score = endSpeed - startSpeed
			
			var huh = endSpeed##Vector2(startSpeed, stats.ply_airspeedcap)
			score = (huh - startSpeed)*speed
			#print(score)
			stack.append(score)
		
		
		
	
	if(stack.size()>30):
		stack.remove_at(0)
	pass
