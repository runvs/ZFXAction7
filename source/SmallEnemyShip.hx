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
class SmallEnemyShip extends EnemyShip
{
	private function new(shootManager : ShootManager) 
	{
		super(shootManager);
		this.makeGraphic(20, 20, FlxColorUtil.makeFromARGB(1, 200, 20, 20));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());

		_guns.add(new SmallSpaceShipGun());
	}
	
	public static function spawn (shootManager : ShootManager, pos: FlxPoint, velX  : Float = 5, velY  : Float = 0 , dir   :Int = 1 ) : EnemyShip
	{
		var e : EnemyShip = new SmallEnemyShip(shootManager);
		e.setPosition(pos.x, pos.y);
		e.velocity.set(velX * dir, velY * dir);
		
		return e;
	}	
}