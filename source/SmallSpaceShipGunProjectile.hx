package ;

import flixel.FlxG;
import flixel.FlxSprite;
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
class SmallSpaceShipGunProjectile extends Projectile
{
	public function new(x: Float, y: Float) 
	{
		super();
		this.makeGraphic(60, 60, FlxColorUtil.makeFromARGB(1, 200, 20, 20));
		//this.origin.set();
		this.acceleration.set(0, 25);
		this.velocity = new FlxPoint(0, 50);
		this.x = x;
		this.y = y;
		this.maxVelocity.set(75, 100);
	}	
	
	public override function update() : Void 
	{
		super.update();
	}
}