package ;

import flixel.FlxG;
import flixel.FlxSprite;
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

	private var _dir : FlxVector;
	private var _bindTimer: Float;
	private var _rotationVelocity : Float;
	
	public function new() 
	{
		super();
		this.makeGraphic(8, 8, FlxColorUtil.makeFromARGB(1, 220, 220, 220));
		this.origin.set(4,4);
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		_bound = false;
		this.angularVelocity = 45;
		_bindTimer = 0.75;
	}
	
	public override function update () :Void
	{
		super.update();
		if (_bound == false)
		{
			this.velocity = new FlxPoint(velocity.x, velocity.y + GameProperties.GetGravitationalAcceleration() * FlxG.elapsed);
		}
		else
		{
			if (_ship  == null)
			{
				_bound = false;
			}
			_dir.rotateByDegrees(_rotationVelocity  * FlxG.elapsed);
		
			this.setPosition(_ship.x + _dir.x, _ship.y + _dir.y);
		}
	}
	
	public function Bind ( e: EnemyShip): Void
	{
		
		if (!_bound)
		{
			
			_bindTimer -= FlxG.elapsed;
			//trace (_bindTimer);
			if (_bindTimer <= 0)
			{
				trace("bind");
				_ship = e;
				_bound = true;
				var v : FlxVector = new FlxVector(this.velocity.x, this.velocity.y);
				var c : Float = _dir.dotProduct(v) / _dir.length / v.length;
				this.velocity.set();
				this.acceleration.set();
				_dir = new FlxVector( -_ship.x  + this.x, -_ship.y  + this.y);
				if (c < 0)
				{
					_rotationVelocity = -45;
				}
				else
				{
					_rotationVelocity = 45;
				}
				
			}
			else
			{
				
				_dir = new FlxVector( e.x  - this.x, e.y  - this.y);
				this.acceleration = new FlxPoint(_dir.x * 50 * FlxG.elapsed, _dir.y * 50 * FlxG.elapsed);
			}
		}
		
	}
	
}