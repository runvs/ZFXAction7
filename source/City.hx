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
		this.loadGraphic(AssetPaths.city__png, false, 640, 163);
		//this.offset.set(0, 163);
		this.setPosition(0, FlxG.height - 32- this.height);
		_guns = new flixel.group.FlxTypedGroup<Gun>();

		//_guns.add(new FlakGun(this, 4, 15, 25, 250, 2));
		//_guns.add(new MissileTurret(this, 1, 15, 25, 250, 10));
		_guns.add(new LaserGun(this, 0, 0, 5));
		_shootManager = shootManager;	
		_population = 10000;
		
		// HUD
		_populationText = new NumberDisplay(true);
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
		

		_flashPoint.x = Std.int(s.x) + region.startX;
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