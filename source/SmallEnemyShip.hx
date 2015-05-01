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
	private var _guns : flixel.group.FlxTypedGroup<Gun>;
	private var _shootManager : ShootManager;

	private function new(shootManager : ShootManager) 
	{
		super();
		this.makeGraphic(20, 20, FlxColorUtil.makeFromARGB(1, 200, 20, 20));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());

		_guns = new flixel.group.FlxTypedGroup<Gun>();
		_guns.add(new SmallSpaceShipGun());

		_shootManager = shootManager;
	}
	
	public static function spawn (shootManager : ShootManager, pos: FlxPoint, velX  : Float = 5, velY  : Float = 0 , dir   :Int = 1 ) : EnemyShip
	{
		var e : EnemyShip = new SmallEnemyShip(shootManager);
		e.setPosition(pos.x, pos.y);
		e.velocity.set(velX * dir, velY * dir);
		
		return e;
	}	

	 private override function shoot() : Void
	{
		for(i in 0..._guns.length)
		{
			if(_guns.members[i].isLoaded())
			{
				_shootManager.addEnemyShot(_guns.members[i].shoot());
			}
		}
	}

	public override function update() : Void
	{
		super.update();
		_guns.update();
		shoot();
	}
}