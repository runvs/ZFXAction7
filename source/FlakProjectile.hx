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
class FlakProjectile extends Projectile
{
	private var _path : flixel.util.FlxPath;

	public function new(path : flixel.util.FlxPath) 
	{
		super();
		makeGraphic(4, 4, FlxColorUtil.makeFromARGB(1, 150, 150, 0));
		_path = path;
	}	

	public override function draw()
	{
		super.draw();
	}

	public override function update()
	{
		super.update();

		if(_path.finished)
		{
			//explode();
		}
		
		_path.update();
	}

	public function explode() : Void
	{
		this.kill();
	}
}