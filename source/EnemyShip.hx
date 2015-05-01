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
class EnemyShip extends FlxSprite
{

	private var _flipFunction :Void -> Void = null;
	
	private function new() 
	{
		super();
		this.makeGraphic(60, 20, FlxColorUtil.makeFromARGB(1, 200, 20, 20));
		this.origin.set();
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		FlxTween.tween(this.offset, { y:10 }, 1, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut } );
		_flipFunction = flipRight;
	}
	
	public function flipLeft() : Void	// flip on left side of the screen
	{
		if (this.x  <  -100)
		{
			this.velocity.set( -this.velocity.x, 0);
			this.scale.set( GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
			_flipFunction = flipRight;
			this.y += FlxRandom.floatRanged( -32, 32);
		}
	}
	public function flipRight() : Void	// flip on right side of the screen
	{
		if (this.x  > FlxG.width + 100)
		{
			this.velocity.set( -this.velocity.x, 0);
			this.scale.set( -GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
			_flipFunction = flipLeft;
			this.y += FlxRandom.floatRanged( -32, 32);
		}
	}

	override public function update():Void 
	{
		super.update();
		_flipFunction();
		shoot();
	}

	private function shoot() : Void
	{

	}	
}