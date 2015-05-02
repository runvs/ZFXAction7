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
		this.makeGraphic(6, 6, FlxColorUtil.makeFromARGB(1, 200, 20, 20));
		this.origin.set();
		this.acceleration.set(0, 5);
		this.x = x;
		this.y = y;
		this.maxVelocity.set(75, 75);
	}	
	
	public override function update() : Void 
	{
		super.update();
	}
}