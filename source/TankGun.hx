package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxSound;
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
class TankGun extends Gun
{
	private var _gunTimer : flixel.util.FlxTimer;
	private var _gunIsReady : Bool;

	private var _accuracy : Float; 	//	1.0 is best
	private var _angularSpread : Float; // in theory, 0 is best
	private var _projectileSpeed : Float;
	
	

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
		_projectileSpeed = 200;
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
		var target : FlxVector = AimOMatic.aim(spawnVector, new FlxVector(targetSprite.x + targetSprite.width/2, targetSprite.y + targetSprite.height/2), new FlxVector(targetSprite.velocity.x, targetSprite.velocity.y), _projectileSpeed);
	
		if(target != null)
		{
			var direction : FlxVector = new FlxVector(target.x - spawnVector.x, target.y - spawnVector.y);
			direction = direction.normalize();

			var velocity : FlxVector = new FlxVector(direction.x * _projectileSpeed, direction.y * _projectileSpeed);	
		
			var minimumLifeTime = 3;
			var maximumLifeTime = 5;
			var projectile : TankProjectile = new TankProjectile(FlxRandom.floatRanged(minimumLifeTime, maximumLifeTime), velocity);
			projectile.x = spawnVector.x;
			projectile.y = spawnVector.y;
			projectiles.add(projectile);
			
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
		return Math.POSITIVE_INFINITY;
	}
}