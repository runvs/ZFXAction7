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
class MissileProjectile extends Projectile
{
	//private var _path : flixel.util.FlxPath;
	private var _engineTimer : flixel.util.FlxTimer;
	private var _target : flixel.FlxSprite;

	public function new(target : FlxSprite, engineStartTime : Float) 
	{
		super();
		makeGraphic(8, 3, FlxColorUtil.makeFromARGB(1, 150, 150, 0));
		_target = target;
		this.velocity.x = 0;
		this.velocity.y = 10;

		this.offset.set(-25, -25);
		FlxTween.tween(this.offset, { x:25, y:25 }, 1, { type:FlxTween.PINGPONG, ease:FlxEase.backInOut } );
		_engineTimer = new flixel.util.FlxTimer(5, null, 1);
	}	

	public override function draw()
	{
		super.draw();
	}

	public override function update()
	{
		super.update();

		if(_engineTimer.finished)
		{
			//AimOMatic.aim(new FlxVector(this.x, this.y), new FlxVector(_target.x, _target.y), new FlxVector(_target.velocity.x, _target.velocity.y), 20);
		}
		
		//_path.update();
	}

	public function explode() : Void
	{
		this.kill();
	}
}