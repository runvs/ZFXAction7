package ;

import flixel.FlxG;
import flixel.FlxSprite;
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
	
	public function new() 
	{
		super();
		this.makeGraphic(8, 8, FlxColorUtil.makeFromARGB(1, 220, 220, 220));
		this.origin.set(4,4);
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		_bound = false;
		this.angularVelocity = 45;
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
			var _dir : FlxVector = new FlxVector(_ship.x - this.x, _ship.y - this.y);
			var l : Float = _dir.length/125;
			_dir.normalize();
			this.acceleration = new FlxPoint(_dir.x * 150 *l*l, _dir.y * 150 * l*l);
			this.velocity = new FlxPoint(velocity.x * 0.9975, velocity.y * 0.9975);
		}
	}
	
	public function Bind ( e: EnemyShip): Void
	{
		if (!_bound)
		{
			trace("bind");
			_ship = e;
			_bound = true;
		}
		//this.velocity = new FlxPoint(0, 0);
	}
	
}