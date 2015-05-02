package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColorUtil;
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
	private var _popText1 : FlxText;
	private var _popText2 : FlxText;

	public function new(shootManager : ShootManager) 
	{
		super();
		this.makeGraphic(320, 16, FlxColorUtil.makeFromARGB(1, 20, 20, 200));
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		this.origin.set(0,0);
		this.setPosition(0, 480 - 32);
		this.updateHitbox();

		_guns = new flixel.group.FlxTypedGroup<Gun>();
		_guns.add(new FlakGun(this, 2,  10, 15, 250, 1));
		//_guns.add(new MissileTurret(this, 3, 15, 25, 250, 1));
		_shootManager = shootManager;	
		_population = 55;
		
		// HUD
		_popText1  = new FlxText(FlxG.width - 110, 10, 100, "", 12);
		_popText1.alignment = "right";
		_popText1.color = FlxColorUtil.makeFromARGB(0.85, 245, 245, 245);
		_popText2  = new FlxText(FlxG.width - 110, 10, 100, "", 12);
		_popText2.alignment = "right";
		_popText2.color = FlxColorUtil.makeFromARGB(0.45, 10, 10, 10);
		_popText2.offset.set (-2, -2);
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

		if(closestShot != null)
		{
			//aim at it
			//return AimOMatic.aim( new flixel.util.FlxVector(gun.x, gun.y), new flixel.util.FlxVector(closestShot.x, closestShot.y), new flixel.util.FlxVector(closestShot.velocity.x, closestShot.velocity.y) , gun.getProjectileSpeed() );	
			
		}
	
		return closestShot;
	}
	
	
	public function drawHud () : Void 
	{
		_popText1.text = Std.string(Std.int(_population));
		_popText2.text = Std.string(Std.int(_population));
		_popText2.draw();
		_popText1.draw();
		
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