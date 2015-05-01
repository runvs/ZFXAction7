package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class Tank extends FlxSprite
{

	private var _bound:Bool;
	public function new() 
	{
		super();
		this.makeGraphic(8, 8, FlxColorUtil.makeFromARGB(1, 220, 220, 220));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		_bound = false;
	}
	
	public override function update () :Void
	{
		super.update();
		if (_bound == false)
		{
			this.velocity = new FlxPoint(velocity.x, velocity.y + GameProperties.GetGravitationalAcceleration() * FlxG.elapsed);
		}
	}
	
}