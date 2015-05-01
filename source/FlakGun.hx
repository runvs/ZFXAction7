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

	public function new(owner : FlxSprite, numberOfBullets : Int, accuracy : Float, angularSpread : Float) 
	{
		super(owner);

		this.makeGraphic(5, 5, FlxColorUtil.makeFromARGB(1, 255, 0, 0));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());

		_gunTimer = new flixel.util.FlxTimer(2, onTimer, 0);
		_gunIsReady = true;		

		_numberOfBullets = numberOfBullets;
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

	public override function shoot(target : FlxVector) : Shot
	{
		_gunIsReady = false;
		return new FlakShot(_numberOfBullets, _accuracy, _angularSpread, this.x, this.y, target.x, target.y);
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
}