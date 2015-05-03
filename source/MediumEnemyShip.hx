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
class MediumEnemyShip extends EnemyShip
{
	private function new() 
	{
		super();
		this.makeGraphic(40, 20, FlxColorUtil.makeFromARGB(1, 200, 20, 20));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
	}
	
	public static function spawn (pos: FlxPoint, velX  : Float = 5, velY  : Float = 0 , dir   :Int = 1 ) : EnemyShip
	{
		var e :EnemyShip = new MediumEnemyShip();
		e.setPosition(pos.x, pos.y);
		e.velocity.set(velX * dir, velY * dir);
		
		return e;
	}	
	
	public override function GetShipStrength () :Float 
	{
		return 2;
	}
}