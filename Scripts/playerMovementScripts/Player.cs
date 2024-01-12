using Godot;
using System;
using playerVariables;
//using System.Numerics;

public partial class Player : PlayerInputs
{
	public CollisionShape3D myShape;
	public PlayerSprite mySkin;
	public ShapeCast3D bonker;
	private SpringArm3D spring;
	private Timer coyoteTimer;
	private Camera3D view;
	private AudioStreamPlayer Step;
	private AnimationPlayer animations;
	private RayCast3D climbCast;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		myShape = GetNode<CollisionShape3D>("CollisionShape3D");
		mySkin = GetNode<PlayerSprite>("Sprite");
		bonker = GetNode<ShapeCast3D>("Headbonk");
		spring = GetNode<SpringArm3D>("TwistPivot/PitchPivot");
		coyoteTimer = GetNode<Timer>("CoyoteTime");
		view = GetNode<Camera3D>("TwistPivot/PitchPivot/view");
		Step = GetNode<AudioStreamPlayer>("step");
		animations = GetNode<AnimationPlayer>("AnimationPlayer");
		climbCast = GetNode<RayCast3D>("climbingCast");

		//get_viewport().GetCamera3d()
		camera = GetNode<Node3D>(stats.camPath);
		GD.Print(stats.vel);
		
		stats.on_floor = false;
		spring.AddExcludedObject(this.GetRid());
		
		animations.Play("running");
	}

	float frame = 0;
	Boolean oddstep = false;
	Boolean stepped = false;
	public Boolean canClimb = false;
	public Vector3 climbAngle = Vector3.Zero;
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		animations.SpeedScale = stats.vel.Length()/2;

		stats.speed = new Vector2(stats.vel[0], stats.vel[2]).Length();
		
	
		
	

		view.Fov = Math.Clamp(70+Mathf.Sqrt(stats.vel.Length()*7),90, 180);
		spring.SpringLength = (float)Math.Clamp( 4 + (Mathf.Sqrt(stats.vel.Length())/1.5),8, 100);

		Vector3 spriteRotation = Vector3.Zero;
		spriteRotation.X = camera.Rotation.X/2;
		spriteRotation.Y = camera.Rotation.Y;
		mySkin.Rotation = spriteRotation;

		Vector3 climbCastRotation = climbCast.Rotation;
		climbCastRotation.Y = camera.Rotation.Y;
		climbCast.Rotation = climbCastRotation;

		Vector3 climbCastPosition = climbCast.TargetPosition;
		climbCastPosition[2] = (float)(stats.speed * -delta* 3)-2;
		climbCast.TargetPosition = climbCastPosition;
		//GD.Print(climbCast.TargetPosition );

		canClimb = climbCast.IsColliding();
		if(canClimb){
			climbAngle = climbCast.GetCollisionNormal() ;
			if (climbAngle.AngleTo(UpDirection) < stats.ply_maxslopeangle){
				
				canClimb = false;
			}
		}


		if(Input.MouseMode == Input.MouseModeEnum.Captured)
		{
			InputKeys();
			
			ViewAngles();
		
		}

		stats.snap = -GetFloorNormal();
		stats.wasOnFloor = stats.on_floor;
	
		Velocity = stats.vel;
		stats.collision = MoveAndSlideOwn();
		stats.vel = Velocity;

	
		
		
		if(stats.wasOnFloor && !stats.on_floor)
		{
			GD.Print("start timer");
			coyoteTimer.Start();
		
		}
		if(stats.on_floor)
		{
			stats.shouldJump = true;
		}
		else
		{
			if(coyoteTimer.IsStopped())
			{
				stats.shouldJump = false;
			
			}
		}
		
	}

	public void ClearCoyote()
	{  
		coyoteTimer.Stop();
		stats.shouldJump = false;
		stats.on_floor = false;
	
	}
	
	public void CheckVelocity()
	{  
		// bound velocity
		// Bound it.
		if(stats.vel.Length() > stats.ply_maxvelocity)
		{
			Vector3 VelDirection = stats.vel.Normalized();
			stats.vel = VelDirection*stats.ply_maxvelocity;
	
		}
		else if (stats.vel.Length() < -stats.ply_maxvelocity){
			Vector3 VelDirection = stats.vel.Normalized();
			stats.vel = VelDirection*stats.ply_maxvelocity;
		}
	}

	//# Perform a move-and-slide along the set velocity vector. If the body collides
	//# with another, it will slide along the other body rather than stop immediately.
	//# The method returns whether || !it collided with anything.
	
	public bool MoveAndSlideOwn()
	{  

		Vector3 currentSpeed = Velocity;
		bool collided  = false;
	
		// Reset previously detected floor
		stats.on_floor  = false;
	
	
		//check floor
		Vector3 checkMotion  = Velocity * (1/60f);
		checkMotion.Y  -= stats.ply_gravity * (1/360f);
			
		KinematicCollision3D testcol  = MoveAndCollide(checkMotion, true);
	
		if(testcol!=null)
		{
			var testNormal = testcol.GetNormal();
			if(testNormal.AngleTo(UpDirection) < stats.ply_maxslopeangle)
			{
				stats.on_floor = true;
	
		// Loop performing the move
			}
		}
		var motion  = Velocity * GetDeltaTime();
		
	
		for(int slide = 0; slide< MaxSlides; slide++)
		{
			
			
			KinematicCollision3D collision  = MoveAndCollide(motion);
			
			if(collision==null)
			{
				// No collision, so move has finished
			
				break;
	
			// Calculate velocity to slide along the surface
		
			}
			Vector3 normal = collision.GetNormal();
			
			motion = collision.GetRemainder().Slide(normal);
			Velocity = Velocity.Slide(normal);
	
	
			// Collision has occurred
			collided = true;
	
	
		}


		stats.lostSpeed = currentSpeed -= Velocity;
		return collided;
		
	}
	
	public float GetDeltaTime()
	{  
		if(Engine.IsInPhysicsFrame())
		{
			return (float)GetPhysicsProcessDeltaTime();
	
		}
		return (float)GetProcessDeltaTime();
	
	
	}
}

/*

using System;
using Godot;
using Dictionary = Godot.Collections.Dictionary;
using Array = Godot.Collections.Array;


public class player1 : PlayerInputs
{
	 
	@onready var myShape = GetNode("CollisionShape3D");
	@onready var mySkin = GetNode("Sprite3D");
	@onready var bonker = GetNode("Headbonk");
	@onready var spring = GetNode("TwistPivot/PitchPivot");
	@onready var coyoteTimer = GetNode("CoyoteTime");
	@onready var view = GetNode("TwistPivot/PitchPivot/view");
	@onready var step = GetNode("step");
	@onready var animations = GetNode("AnimationPlayer");
	
	
	
	public __TYPE height = 2 ;//the model is 2 meter tall
	
	
	public void _Ready()
	{  
		
		mySkin.SetSortingOffset(1);
		//get_viewport().GetCamera3d()
		camera = GetNode(stats.camPath);
		GD.Print(stats.vel);
		
		stats.on_floor = false;
		spring.AddExcludedObject(self.GetRid());
		
		
	
	}
	
	public __TYPE frame = 0;
	
	public bool stepped  = false;
	public bool oddstep  = true;
	
	public void _Process(__TYPE delta)
	{  
		
		view.fov = Mathf.Clamp(70+sqrt(stats.vel.Length()*7),90, 180);
		spring.spring_length = Mathf.Clamp(4+(Mathf.Sqrt(stats.vel.Length())/1.5),8, 100);
		
		if(frame>=10)
		{
			mySkin.frame = 0;
			frame = 0;
			
		
		}
		if(((mySkin.frame == 2 || mySkin.frame ==7)))
		{
			if((stepped ==false))
			{
				oddstep = !oddstep;
				
				if((oddstep))
				{
					step.pitch_scale=1.1;
				}
				else
				{
					step.pitch_scale=0.9;
				
				}
				stepped = true;
				step.Play();
			}
		}
		else
		{
			stepped = false;
		
		}
		mySkin.frame = Mathf.Round(frame);
		GetNode("Sprite3D/color").frame = Mathf.Round(frame);
		//print(mySkin.frame)
		frame+= stats.vel.Length() * delta * 0.6;
		
			
		mySkin.rotation.y = camera.rotation.y;
		mySkin.rotation.x = (camera.rotation.x)/2;
	
				
		if(Input.GetMouseMode() == Input.MOUSE_MODE_CAPTURED)
		{
			InputKeys();
			
			ViewAngles(delta);
		
		}
		stats.snap = -get_floor_normal()
	
		stats.wasOnFloor = stats.on_floor;
	
		
		velocity = stats.vel;
		MoveAndSlideOwn();
		stats.vel = velocity;
		
		
		if(stats.wasOnFloor && !stats.on_floor)
		{
			GD.Print("start timer");
			coyoteTimer.Start();
		
		}
		if((stats.on_floor))
		{
			stats.shouldJump = true;
		}
		else
		{
			if(coyoteTimer.IsStopped())
			{
				stats.shouldJump = false;
				//print("timer stopped")
		
		
			
			}
		}
	}
	
	public void ClearCoyote()
	{  
		coyoteTimer.Stop();
		stats.shouldJump = false;
		stats.on_floor = false;
	
	}
	
	public void CheckVelocity()
	{  
		// bound velocity
		// Bound it.
		if(stats.vel.Length() > stats.ply_maxvelocity)
		{
			stats.vel = stats.ply_maxvelocity;
	
		}
		else if stats.vel.Length() < -stats.ply_maxvelocity:
			stats.vel = -stats.ply_maxvelocity
	
	
	
			
	
	//# Perform a move-and-slide along the set velocity vector. If the body collides
	//# with another, it will slide along the other body rather than stop immediately.
	//# The method returns whether || !it collided with anything.
	}
	
	public bool MoveAndSlideOwn()
	{  
		bool collided  = false;
	
		// Reset previously detected floor
		stats.on_floor  = false;
	
	
		//check floor
		var checkMotion  = velocity * (1/60.);
		checkMotion.y  -= stats.ply_gravity * (1/360.);
			
		var testcol  = MoveAndCollide(checkMotion, true);
	
		if(testcol)
		{
			var testNormal = testcol.GetNormal();
			if(testNormal.AngleTo(upDirection) < stats.ply_maxslopeangle)
			{
				stats.on_floor = true;
	
		// Loop performing the move
			}
		}
		var motion  = velocity * GetDeltaTime();
		
	
		foreach(var step in maxSlides)
		{
			
			
			var collision  = MoveAndCollide(motion);
			
			if(!collision)
			{
				// No collision, so move has finished
			
				break;
	
			// Calculate velocity to slide along the surface
		
			}
			var normal = collision.GetNormal();
			
			motion = collision.GetRemainder().Slide(normal);
			velocity = velocity.Slide(normal);
	
	
			// Collision has occurred
			collided = true;
	
	
		}
		return collided;
		
	}
	
	public float GetDeltaTime()
	{  
		if(Engine.IsInPhysicsFrame())
		{
			return GetPhysicsProcessDeltaTime();
	
		}
		return GetProcessDeltaTime();
	
	
	}
	
	
	
}
*/
