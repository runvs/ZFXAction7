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
	private var _healthMax : Float;
		
	private function new(shootManager : ShootManager) 
	{
		super();
		
		_flipFunction = flipRight;
		_guns = new flixel.group.FlxTypedGroup<Gun>();
		_shootManager = shootManager;	

		FlxTween.tween(this.offset, { y:4 }, 4, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut } );
		
	}
	
	public function flipLeft() : Void	// flip on left side of the screen
	{
		if (this.x  <  -10)
		{
			this.velocity.set( -this.velocity.x, 0);
			this.scale.set( GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
			_flipFunction = flipRight;
			this.y += FlxRandom.floatRanged( 0, 48);
			if (y > FlxG.height / 3)
			{
				y = FlxG.height / 3;
			}
		}
	}
	public function flipRight() : Void	// flip on right side of the screen
	{
		if (this.x  > FlxG.width + 10)
		{
			this.velocity.set( -this.velocity.x, 0);
			this.scale.set( -GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
			_flipFunction = flipLeft;
			this.y += FlxRandom.floatRanged( 0, 48);
			if (y > FlxG.height / 3)
			{
				y = FlxG.height / 3;
			}
		}
	}

	override public function update():Void 
	{
		//trace (x);
		super.update();
		_flipFunction();
		_guns.update();
		shoot();
		checkDead();
	}
	
	public function GetShipStrength () : Float
	{
		return 1;
	}

	private function shoot() : Void
	{
		if (alive)
		{
			for(i in 0..._guns.length)
			{
				if(_guns.members[i].isLoaded())
				{
					var target : FlxSprite = new FlxSprite();
					target.x = this.x;
					target.y = 400;
					//no idea how i can set relative positions.. so ill work around
					var shot : flixel.group.FlxTypedGroup<Projectile> = _guns.members[i].shoot(target);
					_shootManager.addEnemyShot(shot);
				}
			}
		}
	}
	
	private function checkDead(): Void 
	{
		if (health <= 0)
		{
			kill();
		}
	}
	
	public function takeDamage(s:Projectile): Void
	{
		health -= s.Damage; 
	}
}