package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

/**
 * ...
 * @author 
 */
class Tank extends FlxSprite
{

	private var _mode : TankMode;
	public function GetMode () : TankMode { return _mode; };
	
	private var _ship : EnemyShip = null;

	private var _dir : FlxVector;	// r and phi, not x and y
	private var _bindTimer: Float;
	private var _rotationVelocity : Float;
	private var _distance: Float;
	private var _gun : Gun;
	private var _shootManager : ShootManager;
	
	private var _turret : FlxSprite;
	
	public function new(sm : ShootManager) 
	{
		super();
		_shootManager = sm;
		_mode = TankMode.Flight;
		this.angularVelocity = 45;
		_bindTimer = 1.5;
		_gun = new TankGun(this, 0, 0, 3);
		
		// flxsprite stuff
		this.loadGraphic(AssetPaths.tankBase__png, true, 16, 16);
		this.animation.add("drive", [0, 1], 10, true);
		this.animation.play("drive");
		this.origin.set(8, 8);
		
		_turret = new FlxSprite();
		_turret.loadGraphic(AssetPaths.tankTurret__png, true, 32, 16);
		_turret.animation.add("idle", [0], 5, true);
		_turret.animation.add("shoot", [1, 2, 3, 4, 0], 30, false);
		_turret.animation.play("idle");
		_turret.origin.set( 4, 8 );
		
	}
	
	public override function draw() : Void 
	{
		super.draw();
		_turret.draw();
	}
	
	public override function update () :Void
	{
		super.update();

			
		if (_mode == TankMode.Flight)
		{
			this.velocity = new FlxPoint(velocity.x , velocity.y + GameProperties.GetGravitationalAcceleration() * FlxG.elapsed );
			this.velocity = new FlxPoint(velocity.x * 0.994, velocity.y * 0.994);	
			_turret.angle = this.angle;
			
		}
		else if (_mode == TankMode.Bound)
		{
			_gun.update();
			
			if (_gun.isLoaded())
			{
				_shootManager.addPlayerShot(_gun.shoot(_ship));
				_turret.animation.play("shoot");
			}
			
			if (_ship  == null || !_ship.alive)
			{
				_mode = TankMode.Parachute;
				FlxTween.tween(this.offset, { x:40 }, 2, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut } );
				FlxTween.tween(_turret.offset, { x:40 }, 2, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut } );
				
			}
			_dir = new FlxVector( _distance, _dir.y + _rotationVelocity  * FlxG.elapsed);
		
			SetPositionInOrbit();
		}
		else if (_mode == TankMode.Parachute)
		{
			this.velocity = new FlxPoint(velocity.x , velocity.y + GameProperties.GetGravitationalAcceleration() * FlxG.elapsed );
			this.velocity = new FlxPoint(velocity.x * 0.994, velocity.y * 0.994);	
			_turret.angle = this.angle;
		}
		
		_turret.update();
		_turret.x = x + 4;		// 4 is *the* magic number.	//... and needed, because tank base and tank turret sprites do not have the same width.
		_turret.y = y;
	}
	
	private function SetPositionInOrbit() : Void
	{
		var d :FlxVector = new FlxVector(Math.cos(Math.PI / 180 * _dir.y) * _dir.x, Math.sin(Math.PI / 180 * _dir.y) * _dir.x);
		this.setPosition(_ship.x + d.x, _ship.y + d.y);
		_turret.angle = _dir.y + 180;
	}
	
	
	public function Bind ( e: EnemyShip): Void
	{
		
		if (_mode != TankMode.Bound)
		{
			_bindTimer -= FlxG.elapsed;
			if (_bindTimer <= 0)
			{
				_ship = e;
				_mode = TankMode.Bound;
				
				// store velocity vector
				var v : FlxVector = new FlxVector(this.velocity.x, this.velocity.y);
				
				// reset velocity and acceleration to 0 (everything up frm now will be done by manually setting positions.
				FlxTween.tween(this.velocity, { x:0, y:0 }, 2.5, { ease:FlxEase.sineInOut });
				FlxTween.tween(this.acceleration, { x:0, y:0 }, 2.5, { ease:FlxEase.sineInOut });

				// d is the distance vector in x,y from enemy to this.
				var d : FlxVector = new FlxVector( - e.x + this.x, - e.y  + this.y);
				// _dir is the distance vector in r,phi
				_dir = new FlxVector(d.length, d.degrees);
				// calculate tangential vector for distance vector (x,y) -> (y, -x)
				var tangential : FlxVector = new FlxVector(d.y, -d.x);
				// project v to tangential and calculate it's length
				var projv : FlxVector = new FlxVector(v.x, v.y);
				projv = projv.projectTo(tangential);
				var angularVelocity: Float = projv.length;
				
				_distance = d.length;
				
				var c : Float = Math.acos(d.dotProduct(v) / d.length / v.length);
				if (c < Math.PI/2)
				{
					_rotationVelocity = - angularVelocity;
					FlxTween.tween(this, { _rotationVelocity: -45 }, 2.5, { ease:FlxEase.sineInOut } );
				}
				else
				{
					_rotationVelocity = angularVelocity;
					FlxTween.tween(this, { _rotationVelocity:45 }, 2.5, { ease:FlxEase.sineInOut});
				}
				FlxTween.tween(this , {_distance:e.AttractionFieldStrength() }, 2.5,{ ease:FlxEase.sineInOut});
			}
			else
			{
				var d : FlxVector = new FlxVector( e.x - this.x, e.y  - this.y);
				d.normalize();
				this.acceleration  = new FlxPoint(d.x* 25, d.y * 25);
			}
		}
	}
	
}