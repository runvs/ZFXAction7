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
		this.makeGraphic(3, 3, FlxColorUtil.makeFromARGB(1, 200, 20, 20));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		//this.velocity.set(0, 50);
		//this.acceleration.set(0, 5);
		this.velocity.set( 75,0);
		this.x = x;
		this.y = y;
		this.maxVelocity.set(1000, 75);
	}	
	public override function update() : Void 
	{
		
		//if (this.velocity.y > 75 )
		//{
			//this.velocity  = new FlxPoint(velocity.x, 75);
		//}
		
		super.update();
	}
}