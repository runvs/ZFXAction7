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
		this.loadGraphic(AssetPaths.smallEnemy__png, false, 32, 16);
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		this.updateHitbox();
		//this.origin.set(this.width/2, this.height/2);
		_guns.add(new SmallSpaceShipGun(this));
		health = _healthMax = 100;
	}
	
	public static function spawn (shootManager : ShootManager, pos: FlxPoint, velX  : Float = 5, velY  : Float = 0 , dir   :Int = 1 ) : EnemyShip
	{
		var e : EnemyShip = new SmallEnemyShip(shootManager);
		e.setPosition(pos.x, pos.y);
		e.velocity.set(velX * dir, velY * dir);
		if (dir <= 0)
		{
			e.scale.set( -GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		}
		return e;
	}	
}