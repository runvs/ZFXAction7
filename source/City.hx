package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;

/**
 * ...
 * @author 
 */
class City extends FlxSprite
{

	public function new() 
	{
		super();
		this.makeGraphic(320, 16, FlxColorUtil.makeFromARGB(1, 20, 20, 200));
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		this.origin.set(0,0);
		this.setPosition(0, 480-32);
		
	}
	
}