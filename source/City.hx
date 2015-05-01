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

	private var _guns : flixel.group.FlxTypedGroup<Gun>;
	private var _shootManager : ShootManager;

	public function new(shootManager : ShootManager) 
	{
		super();
		this.makeGraphic(320, 100, FlxColorUtil.makeFromARGB(1, 20, 20, 200));
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		this.origin.set(0,0);
		this.setPosition(0, 280);

		_guns = new flixel.group.FlxTypedGroup<Gun>();
		_guns.add(new FlakGun(3, 45, 50));
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
			{
				//yay, we can fire guns! lets look for a target... 
				var target : FlxVector = lookForTarget(_guns.members[i]);
				//no idea how i can set relative positions.. so ill work around
				var shot : Shot = _guns.members[i].shoot(target);
				shot.x = 320;
				shot.y = 240;
				_shootManager.addPlayerShot(shot);
			}
		}
	}	
	
	private function lookForTarget(gun : Gun) : flixel.util.FlxVector
	{
		return new flixel.util.FlxVector(320, 75);
	}
}