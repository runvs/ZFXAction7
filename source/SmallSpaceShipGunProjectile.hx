package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;

/**
 * ...
 * @author 
 */
class SmallSpaceShipGunProjectile extends Projectile
{
	
	var _glow : FlxSprite;
	
	public function new(x: Float, y: Float) 
	{
		super();
		this.makeGraphic(4, 4, FlxColorUtil.makeFromARGB(1, 200, 20, 20));
		this.acceleration.set(0, 25);
		this.velocity = new FlxPoint(0, 50);
		this.x = x;
		this.y = y;
		this.maxVelocity.set(75, 100);
		
		_glow = new FlxSprite();
		_glow.loadGraphic(AssetPaths.projectileEnemyGlow__png, false, 12, 12);
		_glow.scale.set(2, 2);
		_glow.alpha = 0.25;
		_glow.offset.set(4, 4);
		FlxTween.tween(_glow, { alpha:0.5 }, 2.3, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut } );
	}	
	
	public override function update() : Void 
	{
		super.update();
		_glow.setPosition(x, y);
	}
	
	public override function draw() : Void 
	{
		_glow.draw();
		super.draw();
	}
}