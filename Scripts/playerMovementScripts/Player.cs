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
	private AnimationTree animationTree;
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
		animationTree = GetNode<AnimationTree>("AnimationTree");

		//get_viewport().GetCamera3d()
		camera = GetNode<Node3D>(stats.camPath);
		GD.Print(stats.vel);
		
		stats.on_floor = false;
		spring.AddExcludedObject(this.GetRid());
		
		//animations.Play("idle");
	}

	float frame = 0;
	Boolean oddstep = false;
	Boolean stepped = false;
	public Boolean canClimb = false;
	public Vector3 climbAngle = Vector3.Zero;
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		UpdateAnimationParams();
		

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
	
	public void UpdateAnimationParams(){
		//GD.Print("yaya");
		if(stats.vel.Length()<0.1){
			animationTree.Set("parameters/conditions/is_moving", false);
			animationTree.Set("parameters/conditions/is_still", true);
			animationTree.Set("parameters/idle/TimeScale/scale", 5.0);
			//GD.Print("1");
			//animationTree.SpeedScale = 3;
			animations.SpeedScale = 3;
		}else{
			animationTree.Set("parameters/conditions/is_moving", true);
			animationTree.Set("parameters/conditions/is_still", false);
			//animations.SpeedScale = 100;// stats.vel.Length()/2;
			animationTree.Set("parameters/running/TimeScale/scale", stats.vel.Length()/1.5);
			//GD.Print("2");
		}
	}
}

