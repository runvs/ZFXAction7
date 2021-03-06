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

	public function new(owner : FlxSprite, time:Float = 5) 
	{
		super(owner);
		this.makeGraphic(5, 5, FlxColorUtil.makeFromARGB(1, 255, 0, 0));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		_gunTimer = new flixel.util.FlxTimer(time, onTimer, 0);
		_gunIsReady = true;
		//FlxTween.tween(this.offset, { y:10 }, 1, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut } );		
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
		projectiles.add(new SmallSpaceShipGunProjectile(this.x + this._owner.x + this._owner.width/2, this.y + this._owner.y));
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
}