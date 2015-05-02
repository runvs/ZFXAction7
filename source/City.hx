package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVector;
import openfl.display.BitmapData;

/**
 * ...
 * @author 
 */
class City extends FlxSprite
{

	private var _guns : flixel.group.FlxTypedGroup<Gun>;
	private var _shootManager : ShootManager;
	
	private var _population : Float;
	private var _populationText : NumberDisplay;

	public function new(shootManager : ShootManager) 
	{
		super();
		this.makeGraphic(320, 16, FlxColorUtil.makeFromARGB(1, 20, 20, 200));
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		this.origin.set(0,0);
		this.setPosition(0, FlxG.height - 32);
		this.updateHitbox();

		_guns = new flixel.group.FlxTypedGroup<Gun>();
		var leftFlakGun : FlakGun = new FlakGun(this, new FlxVector(50, 0), 4, 15, 25, 250, 2);	
		var rightFlakGun : FlakGun = new FlakGun(this, new FlxVector(FlxG.width - 50, 0), 4, 15, 25, 250, 2);
	
		//_guns.add(leftFlakGun);
		//_guns.add(rightFlakGun);

		var leftMissileTurret : MissileTurret = new MissileTurret(this, new FlxVector(100, 0), 250, 10);
		var rightMissileTurret : MissileTurret = new MissileTurret(this, new FlxVector(FlxG.width - 100, 0), 250, 10);

		//_guns.add(leftMissileTurret);
		//_guns.add(rightMissileTurret);

		var leftLaserGun : LaserGun = new LaserGun(this, new FlxVector(150, 0), 15, 25, 10);
		var rightLaserGun : LaserGun = new LaserGun(this, new FlxVector(FlxG.width - 150, 0), 15, 25, 10);

		_guns.add(leftLaserGun);
		_guns.add(rightLaserGun);

		_shootManager = shootManager;	
		_population = 10000;
		
		// HUD
		_populationText = new NumberDisplay(true);
	}

	override public function draw():Void
	{
		super.draw();
		_guns.draw();
	}

	override public function update():Void 
	{
		super.update();
		_guns.update();
		shoot();
	}

	private function shoot() : Void
	{
		for(i in 0..._guns.length)
		{
			if(_guns.members[i].isLoaded())
			//if(FlxG.keys.anyPressed(["Q"]))
			{
				//yay, we can fire guns! lets look for a target... 
				var target : FlxSprite = lookForTarget(_guns.members[i]);

				if(target == null)
				{
					continue;
				}
				else
				{
					var projectiles : flixel.group.FlxTypedGroup<Projectile> = _guns.members[i].shoot(target);
					_shootManager.addPlayerShot(projectiles);
				}
			}
		}
	}	
	
	private function lookForTarget(gun : Gun) : flixel.FlxSprite
	{
		//look for closest shot
		var closestShot : Projectile = null;
		var distanceOfClosestShot : Float = 812738172381723;
		_shootManager.getEnemyShots().forEachAlive
		(		
			function(shot:Projectile) 
			{ 
				var distance : FlxVector = new FlxVector(gun.x + this.x + this.width/2 - shot.x, gun.y + this.y  - shot.y);
				if (distance.length < distanceOfClosestShot)
				{
					closestShot = shot;
					distanceOfClosestShot = distance.length;
				}
			}
		);

		return closestShot;
	}
	
	
	public function drawHud () : Void 
	{
		_populationText.drawSingleNumber(Std.int(_population), new FlxPoint(FlxG.width - 110, 10));
	}
	
	
	
	public function ShotImpact(s:Projectile)
	{
		var source:FlxSprite = new FlxSprite();
		source.makeGraphic(10, 10, FlxColorUtil.makeFromARGB(0.0, 255, 0, 0));
		
		//////// copy from stamp
		source.drawFrame();
		var bitmapData:BitmapData = source.framePixels;
		

		_flashPoint.x = Std.int(s.x/2) + region.startX;
		_flashPoint.y = Std.int(s.y - this.y) + region.startY;
		_flashRect2.width = bitmapData.width;
		_flashRect2.height = bitmapData.height;
		cachedGraphics.bitmap.copyPixels(bitmapData, _flashRect2, _flashPoint, null, null, false);
		_flashRect2.width = cachedGraphics.bitmap.width;
		_flashRect2.height = cachedGraphics.bitmap.height;
		
		resetFrameBitmapDatas();
		
		#if FLX_RENDER_BLIT
		dirty = true;
		calcFrame();
		#end
		//////// end copy from stamp
		var decimate = _population  * FlxRandom.floatRanged( 0, 0.01) + 50;
		
		checkDead();
		
		
		_population -= decimate;
	}
	
	private function checkDead() : Void 
	{
		if (_population <= 0)
		{
			kill();
		}
	}
	
}