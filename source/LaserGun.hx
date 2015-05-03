package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;
/**
 * ...
 * @author 
 */
class LaserGun extends Gun
{
	private var _gunTimer : flixel.util.FlxTimer;
	private var _gunIsReady : Bool;

	public var _accuracy : Float; 	//	1.0 is best
	public var _angularSpread : Float; // in theory, 0 is best
	public var _rateOfFire : Float;

	public function new(owner : FlxSprite, position : FlxVector, accuracy : Float, angularSpread : Float, reloadTime : Float)
	{
		super(owner);

		this.loadGraphic(AssetPaths.turretLaser__png, true, 16, 16);
		this.scale.set(2, 2);
		this.animation.add("idle", [0]);
		this.animation.add("shoot", [1, 2, 3, 4, 5, 6, 7,0], 15, false );
		this.animation.play("idle");
		
		this.x = owner.x + position.x;
		this.y = owner.y + position.y;
		
		_rateOfFire = reloadTime;
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
		this.animation.play("shoot");

		var projectiles : flixel.group.FlxTypedGroup<Projectile> = new flixel.group.FlxTypedGroup<Projectile>();

		var spawnVector : FlxVector = new FlxVector(this.x + this.width/2, this.y - this.height/2);
		
		if(targetSprite != null)
		{
			var pathVector : FlxVector = new FlxVector(targetSprite.x + targetSprite.width/2 - spawnVector.x, targetSprite.y + targetSprite.height/2 - spawnVector.y);
				
			pathVector = pathVector.rotateByDegrees(FlxRandom.floatRanged(-_angularSpread/2, _angularSpread/2));
			pathVector = pathVector.addNew(spawnVector);
					
			var startPoint : FlxVector = spawnVector;
			var endPoint : FlxVector = new FlxVector(targetSprite.x + targetSprite.width/2, targetSprite.y + targetSprite.height/2);//new FlxVector(pathVector.x + FlxRandom.floatRanged(-_accuracy, _accuracy), pathVector.y + FlxRandom.floatRanged(-_accuracy, _accuracy));
				
			var beam : Projectile = new LaserBeam(targetSprite, startPoint, endPoint);

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

	public override function prefersCloseTarget() : Bool
	{
		return true;
	}

	public override function prefersFarTarget() : Bool
	{
		return true;
	}	
}