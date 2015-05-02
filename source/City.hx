package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
import flixel.util.FlxVector;


/**
 * ...
 * @author 
 */
class City extends FlxSprite
{

	private var _guns : flixel.group.FlxTypedGroup<Gun>;
	private var _shootManager : ShootManager;

	public function new(shootManager : ShootManager) 
	{
		super();
		this.makeGraphic(320, 16, FlxColorUtil.makeFromARGB(1, 20, 20, 200));
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		this.origin.set(0,0);
		this.setPosition(0, 480-32);

		_guns = new flixel.group.FlxTypedGroup<Gun>();
		_guns.add(new FlakGun(this, 3, 0, 0, 150, 10));
		_shootManager = shootManager;	
	}

	override public function update():Void 
	{
		super.update();
		_guns.update();
		shoot();
	}

	private function shoot() : Void
	{
		for(i in 0..._guns.length)
		{
			if(_guns.members[i].isLoaded())
			//if(FlxG.keys.anyPressed(["Q"]))
			{
				//yay, we can fire guns! lets look for a target... 
				var target : flixel.util.FlxVector = lookForTarget(_guns.members[i]);

				if(target == null)
				{
					continue;
				}
				else
				{
					var shot : Shot = _guns.members[i].shoot(target);
					_shootManager.addPlayerShot(shot);
				}
			}
		}
	}	
	
	private function lookForTarget(gun : Gun) : flixel.util.FlxVector
	{
		//look for closest shot
		var closestShot : Shot = null;
		var distanceOfClosestShot : Float = 812738172381723;
		_shootManager.getEnemyShots().forEachAlive
		(		
			function(shot:Shot) 
			{ 
				var distance : FlxVector = new FlxVector(gun.x - shot.x, gun.y - shot.y);
				if (distance.length < distanceOfClosestShot)
				{
					closestShot = shot;
					distanceOfClosestShot = distance.length;
				}
			}
		);

		if(closestShot != null)
		{
			//aim at it
			return AimOMatic.aim( new flixel.util.FlxVector(gun.x, gun.y), new flixel.util.FlxVector(closestShot.x, closestShot.y), new flixel.util.FlxVector(closestShot.velocity.x, closestShot.velocity.y) , gun.getProjectileSpeed() );	
		}
	
		return null;
	}
}