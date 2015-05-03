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

	public var _numberOfBullets : Int;
	public var _accuracy : Float; 
	public var _angularSpread : Float;

	public var _projectileSpeed : Float;
	private var _turret : FlxSprite;

	public function new(owner : FlxSprite, position : FlxVector, numberOfBullets : Int, accuracy : Float, angularSpread : Float, projectileSpeed : Float, reloadTime : Float)
	{
		super(owner);

		this.x = owner.x + position.x;
		this.y = owner.y + position.y;
		
		this.loadGraphic(AssetPaths.turretFlakBase__png, false, 16, 16);
		this.scale.set(2, 2);
		_turret = new FlxSprite();
		_turret.loadGraphic(AssetPaths.turretFlakCannon__png, false, 16, 16);
		_turret.origin.set(8, 9);
		_turret.scale.set(2, 2);
		_turret.setPosition ( x, y);
		


		_gunTimer = new flixel.util.FlxTimer(reloadTime, onTimer, 0);
		_gunIsReady = true;		

		_numberOfBullets = numberOfBullets;
		_accuracy = accuracy;
		_angularSpread = angularSpread;
		_projectileSpeed = projectileSpeed;
		
		FlxTween.tween(_turret, { angle:-180 }, 3.5, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut } );
		
	}
	
	public override function update() : Void 
	{
		super.update();	
		_gunTimer.update();
	}
	
	
	public override function draw() : Void 
	{
		super.draw();
		_turret.draw();
	}

	public override function shoot(targetSprite : FlxSprite) : flixel.group.FlxTypedGroup<Projectile>
	{
		_gunIsReady = false;
		
		var projectiles : flixel.group.FlxTypedGroup<Projectile> = new flixel.group.FlxTypedGroup<Projectile>();

		var spawnVector : FlxVector = new FlxVector(this.x, this.y);
		var target : FlxVector = AimOMatic.aim(spawnVector, new FlxVector(targetSprite.x, targetSprite.y), new FlxVector(targetSprite.velocity.x, targetSprite.velocity.y), _projectileSpeed);
	
		if(target != null)
		{
			for(i in 0..._numberOfBullets)
			{
				var pathVector : FlxVector = new FlxVector(target.x - spawnVector.x, target.y - spawnVector.y);
				
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

	public override function prefersCloseTarget() : Bool
	{
		return true;
	}

	public override function prefersFarTarget() : Bool
	{
		return false;
	}
}