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

	private var _dir : FlxVector;
	
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
			_dir.rotateByDegrees(45 * FlxG.elapsed);
		
			this.setPosition(_ship.x + _dir.x, _ship.y + _dir.y);
		}
		
	}
	
	public function Bind ( e: EnemyShip): Void
	{
		if (!_bound)
		{
			trace("bind");
			_ship = e;
			_bound = true;
			this.velocity.set();
			_dir = new FlxVector(-_ship.x  + this.x, -_ship.y  + this.y);
		}
		
	}
	
}