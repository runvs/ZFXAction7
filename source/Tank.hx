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

	private var _bound:Bool;
	
	private var _ship : EnemyShip = null;

	private var _dir : FlxVector;	// r and phi, not x and y
	private var _bindTimer: Float;
	private var _rotationVelocity : Float;
	private var _distance: Float;
	private var _gun : Gun;
	private var _shootManager : ShootManager;
	
	public function new(sm : ShootManager) 
	{
		super();
		_shootManager = sm;
		this.makeGraphic(8, 8, FlxColorUtil.makeFromARGB(1, 220, 220, 220));
		this.origin.set(4,4);
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		_bound = false;
		this.angularVelocity = 45;
		_bindTimer = 1.5;
		_gun = new FlakGun(this, 1, 10, 10, 250, 1);
	}
	
	public override function update () :Void
	{
		super.update();
		if (_bound == false)
		{
			this.velocity = new FlxPoint(velocity.x , velocity.y + GameProperties.GetGravitationalAcceleration() * FlxG.elapsed );
			this.velocity = new FlxPoint(velocity.x * 0.994, velocity.y * 0.994);
		}
		else
		{
			_gun.update();
			
			if (_gun.isLoaded())
			{
				//_shootManager.addPlayerShot(_gun.shoot(AimOMatic.aim(new FlxVector(x, y), new FlxVector(_ship.x, _ship.y), new FlxVector(_ship.velocity.x, _ship.velocity.y), _gun.getProjectileSpeed())));
				_shootManager.addPlayerShot(_gun.shoot(_ship));
			}
			
			if (_ship  == null)
			{
				_bound = false;
			}
			_dir = new FlxVector( _distance, _dir.y + _rotationVelocity  * FlxG.elapsed);
		
			SetPositionInOrbit();
		}
	}
	
	private function SetPositionInOrbit() : Void
	{
		var d :FlxVector = new FlxVector(Math.cos(Math.PI / 180 * _dir.y) * _dir.x, Math.sin(Math.PI / 180 * _dir.y) * _dir.x);
		this.setPosition(_ship.x + d.x, _ship.y + d.y);
	}
	
	
	public function Bind ( e: EnemyShip): Void
	{
		
		if (!_bound)
		{
			
			_bindTimer -= FlxG.elapsed;
			if (_bindTimer <= 0)
			{
				_ship = e;
				_bound = true;
				
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
				FlxTween.tween(this , {_distance:100 }, 2.5,{ ease:FlxEase.sineInOut});
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