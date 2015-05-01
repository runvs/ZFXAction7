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
class SmallSpaceShipGun extends Gun
{
	private var _gunTimer : flixel.util.FlxTimer;
	private var _gunIsReady : Bool;

	public function new() 
	{
		super();
		this.makeGraphic(5, 5, FlxColorUtil.makeFromARGB(1, 255, 0, 0));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		_gunTimer = new flixel.util.FlxTimer(5, onTimer, 0);
		//_gunTimer.start();
		_gunIsReady = true;
		//FlxTween.tween(this.offset, { y:10 }, 1, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut } );		
	}
	
	public override function update() : Void 
	{
		super.update();	
		_gunTimer.update();
		//trace("gun update");
	}
	
	
	public override function draw() : Void 
	{
		super.draw();
	}

	public override function shoot() : Shot
	{
		_gunIsReady = false;
		return new SmallShot(this.x, this.y);
	}

	private function onTimer(timer:flixel.util.FlxTimer) : Void
	{
		//unlimited ammo!
		trace("onTimer");
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