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
class LaserBeam extends Projectile
{
	private var _start : FlxVector;
	private var _end : FlxVector;

	private var _fadeOutTime : Float;

	private var _fadeOutTimer : flixel.util.FlxTimer;

	public function new(start : FlxVector, end : FlxVector) 
	{
		super();

		_start = start;
		_end = end;
	
		makeGraphic(2, 1, FlxColorUtil.makeFromARGB(1, 0, 255, 0));
		_fadeOutTime = 0.5;

		//stretch and rotate
		var length : Float = start.dist(end);
		this.setGraphicSize(2, Std.int(length));
		origin.set();

		var startToEnd : FlxVector = new FlxVector(end.x - start.x , end.y - start.y);
		this.angle = - startToEnd.degreesBetween(new FlxVector(0, 1));
	
		_fadeOutTimer = new flixel.util.FlxTimer(_fadeOutTime, null, 1);


		this.x = start.x;
		this.y = start.y;	
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
	}

	public function explode() : Void
	{
		this.kill();
	}
}