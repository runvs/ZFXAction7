package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
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
class LaserBeam extends Projectile
{
	private var _start : FlxVector;
	private var _end : FlxVector;

	private var _fadeOutTime : Float;

	private var _fadeOutTimer : flixel.util.FlxTimer;

	private var _path : flixel.util.FlxPath;

	private var _target : FlxSprite;
	
	private var _sound : FlxSound;

	public function new(target : FlxSprite, start : FlxVector, end : FlxVector) 
	{
		//lets try the old way with good optics and use ppc
		super();
		_target = target;
		_start = start;
		_end = end;

		var length : Float = start.dist(end);	
		makeGraphic(3, Std.int(length + 0.5), FlxColorUtil.makeFromARGB(1, 0, 255, 0), true);
			
		_fadeOutTime = 1;

		var startToEnd : FlxVector = new FlxVector(end.x - start.x , end.y - start.y);
	
		_fadeOutTimer = new flixel.util.FlxTimer(_fadeOutTime, null, 1);
		origin.set(0, 0);
		offset.set(0, 0);
		this.x = start.x;
		this.y = start.y;
		var targetAngle = startToEnd.degreesBetween(new FlxVector(0, 1)); 
		//trace(_end);
		if(_end.x > start.x)
		{
			this.angle = -targetAngle;
		}
		else
		{
			this.angle = targetAngle;
		}
		
		_sound = new FlxSound();
		_sound = FlxG.sound.load(AssetPaths.lasershoot1__mp3, 0.5);
		_sound.play();
		
		FlxTween.tween(this, { alpha: 0 }, _fadeOutTime, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut } );
		_target.hurt(10);
	}	

	public override function draw()
	{
		super.draw();
	}

	public override function update()
	{
		super.update();

		if(_fadeOutTimer.finished)
		{
			explode();
		}
		_fadeOutTimer.update();
		// if(_path.finished)
		// {
		// 	explode();
		// }
		//_path.update();
	}

	public override function explode() : Void
	{
		this.kill();
		
	}
}