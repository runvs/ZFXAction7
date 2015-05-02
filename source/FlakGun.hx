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

	public override function shoot(target : FlxVector) : Shot
	{
		_gunIsReady = false;
		return new FlakShot(_numberOfBullets, _accuracy, _angularSpread, _projectileSpeed, this.x + this._owner.x + this._owner.width/2, this.y + this._owner.y, target.x, target.y);
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