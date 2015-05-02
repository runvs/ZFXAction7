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
class FlakGun extends Gun
{
	private var _gunTimer : flixel.util.FlxTimer;
	private var _gunIsReady : Bool;

	private var _numberOfBullets : Int;
	private var _accuracy : Float; 	//	1.0 is best
	private var _angularSpread : Float; // in theory, 0 is best

	private var _projectileSpeed : Float;

	public function new(owner : FlxSprite, numberOfBullets : Int, accuracy : Float, angularSpread : Float, projectileSpeed : Float, reloadTime : Float)
	{
		super(owner);

		this.makeGraphic(5, 5, FlxColorUtil.makeFromARGB(1, 255, 0, 0));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());

		_gunTimer = new flixel.util.FlxTimer(reloadTime, onTimer, 0);
		_gunIsReady = true;		

		_numberOfBullets = numberOfBullets;
		_accuracy = accuracy;
		_angularSpread = angularSpread;
		_projectileSpeed = projectileSpeed;
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
		var target : FlxVector = AimOMatic.aim(new FlxVector(this.x, this.y), new FlxVector(targetSprite.x, targetSprite.y), new FlxVector(targetSprite.velocity.x, targetSprite.velocity.y), _projectileSpeed);
		
		if(target != null)
		{
			for(i in 0..._numberOfBullets)
			{
				var spawnVector : FlxVector = new FlxVector(this.x + this._owner.x + this._owner.width/2, this.y + this._owner.y);
				var targetVector : FlxVector = new FlxVector(target.x, target.y);
				var pathVector : FlxVector = new FlxVector(targetVector.x - spawnVector.x, targetVector.y - spawnVector.y);
				
				pathVector = pathVector.rotateByDegrees(FlxRandom.floatRanged(-_angularSpread/2, _angularSpread/2));
				pathVector = pathVector.addNew(spawnVector);
				
				var path : flixel.util.FlxPath = new flixel.util.FlxPath();
				var pathPoints : Array<flixel.util.FlxPoint> = new Array<FlxPoint>();
				var endPoint : FlxPoint = new FlxPoint(pathVector.x + FlxRandom.floatRanged(-_accuracy, _accuracy), pathVector.y + FlxRandom.floatRanged(-_accuracy, _accuracy));
				
				pathPoints.push(endPoint);

				var projectile : FlakProjectile = new FlakProjectile(path);
				projectile.x = spawnVector.x;
				projectile.y = spawnVector.y;
				projectiles.add(projectile);
				path.start(projectile, pathPoints, _projectileSpeed, flixel.util.FlxPath.FORWARD, true);
			}			
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
		return _projectileSpeed;
	}
}