package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
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
	private var _explosion : FlxSprite;
	private var _exploded : Bool;
	private var _explodeSound : FlxSound;
	
	public function new(path : flixel.util.FlxPath) 
	{
		super();
		makeGraphic(2, 2, FlxColorUtil.makeFromARGB(1, 34, 32, 52));
		_path = path;
		Damage = 10;
		_exploded = false;
		
		// FlxSprite stuff
		_explosion = new FlxSprite();
		_explosion.loadGraphic(AssetPaths.explosionFlak__png, true, 32, 32);
		_explosion.animation.add("idle", [0], 30, true);
		_explosion.animation.add("explode", [1, 2, 3, 4, 5, 6, 7, 8], 23, false);
		_explosion.animation.play("idle");
		var s : Float = FlxRandom.floatRanged(0.5, 2);
		_explosion.scale.set(s,s);
		_explosion.updateHitbox();
		
		// FlxSound stuff
		_explodeSound = FlxG.sound.load(AssetPaths.explo1__mp3, 0.35);
		
	}	

	public override function draw()
	{
		if (!_exploded)
		{
			super.draw();
		}
		_explosion.draw();
	}

	public override function update()
	{
		super.update();
		_explosion.update();
		if(_path.finished)
		{
			explode();
		}
		
		_path.update();
	}

	public override function explode() : Void
	{
		if (!_exploded )
		{
			_exploded = true;
			_explosion.setPosition(x, y);
			_explosion.animation.play("explode", true);
			this.width = _explosion.width;		// try to trick the collisions
			this.height = _explosion.height;
			var t : FlxTimer = new FlxTimer(9.0 / 20.0, function(t:FlxTimer) { this.kill(); } );
			
			_explodeSound.pan = (x / FlxG.width * 2) - 1;
			
			_explodeSound.play();
		}
	}
}