package ;

import flixel.FlxSprite;
import flixel.FlxG;
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
class LaserGun extends Gun
{
	private var _gunTimer : flixel.util.FlxTimer;
	private var _gunIsReady : Bool;

	private var _accuracy : Float; 	//	1.0 is best
	private var _angularSpread : Float; // in theory, 0 is best

	public function new(owner : FlxSprite, accuracy : Float, angularSpread : Float, reloadTime : Float)
	{
		super(owner);

		this.makeGraphic(5, 5, FlxColorUtil.makeFromARGB(1, 255, 0, 0));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());

		_gunTimer = new flixel.util.FlxTimer(reloadTime, onTimer, 0);
		_gunIsReady = true;		

		_accuracy = accuracy;
		_angularSpread = angularSpread;
	}
	
	public override function update() : Void 
	{
		super.update();	
		_gunTimer.update();
	}
	
	
	public override function draw() : Void 
	{
		super.draw();
	}

	public override function shoot(targetSprite : FlxSprite) : flixel.group.FlxTypedGroup<Projectile>
	{
		_gunIsReady = false;
		var projectiles : flixel.group.FlxTypedGroup<Projectile> = new flixel.group.FlxTypedGroup<Projectile>();

		var spawnVector : FlxVector = new FlxVector(this.x + this._owner.x + this._owner.width/2, this.y + this._owner.y);
		
		if(targetSprite != null)
		{
			var pathVector : FlxVector = new FlxVector(targetSprite.x - spawnVector.x, targetSprite.y - spawnVector.y);
				
			pathVector = pathVector.rotateByDegrees(FlxRandom.floatRanged(-_angularSpread/2, _angularSpread/2));
			pathVector = pathVector.addNew(spawnVector);
					
			var startPoint : FlxVector = spawnVector;
			var endPoint : FlxVector = new FlxVector(targetSprite.x + targetSprite.width/2, targetSprite.y);//new FlxVector(pathVector.x + FlxRandom.floatRanged(-_accuracy, _accuracy), pathVector.y + FlxRandom.floatRanged(-_accuracy, _accuracy));
				
			var beam : Projectile = new LaserBeam(startPoint, endPoint);

			projectiles.add(beam);	
		}

		return projectiles;
	}

	private function onTimer(timer:flixel.util.FlxTimer) : Void
	{
		//unlimited ammo!
		reload();
	}

	public override function reload() : Void
	{
		_gunIsReady = true;
	}

	public override function isLoaded()
	{
		return _gunIsReady;
	}

	public override function getProjectileSpeed() : Float
	{
		return 250;
	}
}