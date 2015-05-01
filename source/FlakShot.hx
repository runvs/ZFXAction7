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
class FlakShot extends Shot
{
	private var bullets : flixel.group.FlxSpriteGroup;
	private var bulletPaths : Array<flixel.util.FlxPath>;

	public function new(numberOfBullets : Int, accuracy : Float, angularSpread : Float, x : Float, y : Float, targetX : Float, targetY : Float) 
	{
		super();

		bullets = new flixel.group.FlxSpriteGroup(x, y, numberOfBullets);
		bulletPaths = new Array<flixel.util.FlxPath>();

		for(i in 0...numberOfBullets)
		{
			var bullet : FlxSprite = new FlxSprite(320, 240);
			bullet.makeGraphic(4, 4, FlxColorUtil.makeFromARGB(1, 20, 20, 200));
			bullets.add(bullet);

			var spawnVector : FlxVector = new FlxVector(320, 240);
			var targetVector : FlxVector = new FlxVector(targetX, targetY);
			var pathVector : FlxVector = new FlxVector(targetVector.x - spawnVector.x, targetVector.y - spawnVector.y);
			pathVector = pathVector.rotateByDegrees(FlxRandom.floatRanged(-angularSpread/2, angularSpread/2));
			pathVector = pathVector.addNew(spawnVector);

			var bulletPath : flixel.util.FlxPath = new flixel.util.FlxPath();
			var path : Array<flixel.util.FlxPoint> = new Array<FlxPoint>();
			var endPoint : FlxPoint = new FlxPoint(pathVector.x + FlxRandom.floatRanged(-accuracy, accuracy), pathVector.y + FlxRandom.floatRanged(-accuracy, accuracy));
			path.push(endPoint);
			bulletPath.start(bullet, path, 25, flixel.util.FlxPath.FORWARD, true);
			bulletPaths.push(bulletPath);
		}
	}	

	public override function draw()
	{
		//super.draw();
		bullets.draw();
	}

	public override function update()
	{
		super.update();

		for(i in 0...bulletPaths.length)
		{
			var path : flixel.util.FlxPath = bulletPaths[i];
			if(path.finished)
			{
				explode(bullets.members[i]);
			}
		}
		bullets.update();

		if(bullets.countLiving() == 0)
		{
			this.kill();
		}
	}

	public function explode(bullet : FlxSprite) : Void
	{
		bullet.kill();
	}
}