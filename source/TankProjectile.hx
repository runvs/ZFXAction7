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
 * Flaks are defined by
 *		"number of bullets" -> describes the number of bullets like shotguns 
 *		"accuracy" -> describes how accurate the flak cannons aim at their desired 
 						target
 *		"density"  -> how close the bullets explode to each other
 *				
 *		
 * @author 
 */
class TankProjectile extends Projectile
{
	private var _lifetimeTimer : flixel.util.FlxTimer;

	public function new(lifetime : Float, velocity : FlxVector) 
	{
		super();
		_lifetimeTimer = new flixel.util.FlxTimer(lifetime, null, 1);

		makeGraphic(4, 4, FlxColorUtil.makeFromARGB(1, 150, 150, 0));
		this.velocity = velocity;
		Damage = 10;
	}	

	public override function draw()
	{
		super.draw();
	}

	public override function update()
	{
		super.update();

		if(_lifetimeTimer.finished)
		{
			explode();
		}

		_lifetimeTimer.update();
	}

	public override function explode() : Void
	{
		this.kill();
	}
}