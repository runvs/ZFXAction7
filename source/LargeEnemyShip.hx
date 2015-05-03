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
class LargeEnemyShip extends EnemyShip
{
	private function new(shootManager : ShootManager) 
	{
		super(shootManager);
		this.loadGraphic(AssetPaths.bigEnemy__png, false, 64, 16);
		
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());

		this.updateHitbox();
		//this.origin.set(this.width/2, this.height/2);
		var g : SmallSpaceShipGun = new SmallSpaceShipGun(this, 4.25);
		g.x = -50;
		g.y = 8;
		_guns.add(g);
		
		g =new SmallSpaceShipGun(this, 5.1);
		g.x = 50;
		_guns.add(g);
		health = _healthMax = 200;
	}
	
	public static function spawn (shootManager : ShootManager, pos: FlxPoint, velX  : Float = 5, velY  : Float = 0 , dir   :Int = 1 ) : EnemyShip
	{
		var e : EnemyShip = new LargeEnemyShip(shootManager);
		e.setPosition(pos.x, pos.y);
		e.velocity.set(velX * dir, velY * dir);
		
		return e;
	}	
	
	public override function GetShipStrength () :Float
	{
		return 2;
	}
	public override function AttractionFieldStrength() : Float 
	{
		return 160;
	}
}