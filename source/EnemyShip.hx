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
	private var _guns : flixel.group.FlxTypedGroup<Gun>;
	private var _shootManager : ShootManager;

	private function new(shootManager : ShootManager) 
	{
		super();
		FlxTween.tween(this.offset, { y:10 }, 1, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut } );
		_flipFunction = flipRight;
		_guns = new flixel.group.FlxTypedGroup<Gun>();
		_shootManager = shootManager;	
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
		_guns.update();
		shoot();
	}

	private function shoot() : Void
	{
		for(i in 0..._guns.length)
		{
			if(_guns.members[i].isLoaded())
			{
				//no idea how i can set relative positions.. so ill work around
				var shot : Shot = _guns.members[i].shoot();
				shot.x = this.x;
				shot.y = this.y;
				_shootManager.addEnemyShot(shot);
			}
		}
	}
}