package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVector;

/**
 * ...
 * @author 
 */
class Projectile extends FlxSprite
{
	public var Damage : Float;
	
	public function new() 
	{
		super();
		this.health = 10;
	}	
	public function explode () : Void 
	{
		kill();
	}
}