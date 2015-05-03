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
class MissileTurret extends Gun
{
	private var _gunTimer : flixel.util.FlxTimer;
	private var _gunIsReady : Bool;

	public var _numberOfBullets : Int;
	public var _accuracy : Float; 	//	1.0 is best
	public var _angularSpread : Float; // in theory, 0 is best

	public var _projectileSpeed : Float;
	public var _rateOfFire : Float;

	public function new(owner : FlxSprite, position : FlxVector, projectileSpeed : Float, reloadTime : Float)
	{
		super(owner);

		this.makeGraphic(10, 2, FlxColorUtil.makeFromARGB(1, 100, 100, 150));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());

		this.x = owner.x + position.x;
		this.y = owner.y + position.y;
		_rateOfFire = reloadTime;
		_gunTimer = new flixel.util.FlxTimer(reloadTime, onTimer, 0);
		_gunIsReady = true;		
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

	public override function shoot(target : FlxSprite) : flixel.group.FlxTypedGroup<Projectile>
	{
		_gunIsReady = false;
		var projectiles : flixel.group.FlxTypedGroup<Projectile> = new flixel.group.FlxTypedGroup<Projectile>();

		//missile turret initially shoots out the missile in a linear direction 
		//before the missiles own engine starts
		var projectile : MissileProjectile = new MissileProjectile(target, 5);
		projectile.x = this.x;
		projectile.y = this.y;
		//the missile then tracks the target itself since its guided
		projectiles.add(projectile);

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