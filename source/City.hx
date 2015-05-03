package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
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

	public var _guns : flixel.group.FlxTypedGroup<Gun>;
	private var _shootManager : ShootManager;
	private var _playState : PlayState;

	private var _population : Float;
	private var _populationText : NumberDisplay;

	private var _flakUpdateScreen : FlakUpdateScreen;
	private var _lasergunUpdateScreen : LaserUpdateScreen;
	private var _missileTurretUpgradeScreen : MissileTurretUpgradeScreen;
	
	public var _leftFlakGun : FlakGun;
	public var _rightFlakGun : FlakGun;

	public var _leftMissileTurret : MissileTurret;
	public var _rightMissileTurret : MissileTurret;

	public var _leftLaserGun : LaserGun;
	public var _rightLaserGun : LaserGun;

	private var _missileLauncherIcon : FlxSprite;
	private var _missileLauncherIconText : FlxText;

	private var _flakCannonIcon : FlxSprite;
	private var _flakCannonIconText : FlxText;

	private var _laserGunIcon : FlxSprite;
	private var _laserGunIconText : FlxText;
	
	private var _hitSound : FlxSound;

	public function new(shootManager : ShootManager, playState : PlayState) 
	{
		super();

		_playState = playState;

		this.loadGraphic(AssetPaths.city__png, false, 640, 163);
		//this.offset.set(0, 163);
		this.setPosition(0, FlxG.height - 32 - this.height);

		_flakCannonIcon = new FlxSprite();
		_flakCannonIcon.makeGraphic(10, 10, FlxColorUtil.makeFromARGB(1, 255, 255, 255), true);
		_flakCannonIcon.x = FlxG.width - 30;
		_flakCannonIcon.y = FlxG.height - 0.75 * FlxG.height;

		_flakCannonIconText = new FlxText(FlxG.width - 40, FlxG.height - 0.73 * FlxG.height, -1, "0/2", 16);

		_missileLauncherIcon = new FlxSprite();
		_missileLauncherIcon.makeGraphic(10, 10, FlxColorUtil.makeFromARGB(1, 255, 255, 255), true);
		_missileLauncherIcon.x = FlxG.width - 30;
		_missileLauncherIcon.y = FlxG.height - 0.65 * FlxG.height;

		_missileLauncherIconText = new FlxText(FlxG.width - 40, FlxG.height - 0.63 * FlxG.height, -1, "0/2", 16);

		_laserGunIcon = new FlxSprite();
		_laserGunIcon.makeGraphic(10, 10, FlxColorUtil.makeFromARGB(1, 255, 255, 255), true);
		_laserGunIcon.x = FlxG.width - 30;
		_laserGunIcon.y = FlxG.height - 0.55 * FlxG.height;

		_laserGunIconText = new FlxText(FlxG.width - 40, FlxG.height - 0.53 * FlxG.height, -1, "0/2", 16);

		_guns = new flixel.group.FlxTypedGroup<Gun>();
		_leftFlakGun = new FlakGun(this, new FlxVector(50, this.height), 3, 50, 35, 250, 2);	
		_rightFlakGun = new FlakGun(this, new FlxVector(FlxG.width - 50, this.height), 3, 15, 25, 250, 2);
	
		//we have flak guns by default
		_guns.add(_leftFlakGun);
		_guns.add(_rightFlakGun);

		_shootManager = shootManager;	
		_population = 10000;
		
		// HUD
		_populationText = new NumberDisplay(true);

		flixel.plugin.MouseEventManager.add(_leftFlakGun, showFlakUpgrades, null, null, null);
		flixel.plugin.MouseEventManager.add(_rightFlakGun, showFlakUpgrades, null, null, null);

		flixel.plugin.MouseEventManager.add(_laserGunIcon, addLaserGun, null, null, null);
		flixel.plugin.MouseEventManager.add(_missileLauncherIcon, addMissileLauncher, null, null, null);
		
		// Sound 
		_hitSound = new FlxSound();
		_hitSound = FlxG.sound.load(AssetPaths.cityexplo__mp3, 0.9, false);
	}

	public function showFlakUpgrades(sprite:FlxSprite)
	{
		var spriteAsFlak : FlakGun = cast sprite;
		_playState.openSubState(new FlakUpdateScreen(spriteAsFlak));
	}

	public function showLaserUpgrades(sprite:FlxSprite)
	{
		var spriteAsLaser : LaserGun = cast sprite;
		_playState.openSubState(new LaserUpdateScreen(spriteAsLaser));
	}

	public function showMissileUpgrades(sprite:FlxSprite)
	{
		var spriteAsMissileLauncher : MissileTurret = cast sprite;
		_playState.openSubState(new MissileTurretUpgradeScreen(spriteAsMissileLauncher));
	}	

	private function addLaserGun(sprite:FlxSprite):Void
	{
		if(_leftLaserGun == null)
		{
			_leftLaserGun = new LaserGun(this, new FlxVector(150, this.height), 15, 25, 10);
			_guns.add(_leftLaserGun);
			flixel.plugin.MouseEventManager.add(_leftLaserGun, showLaserUpgrades, null, null, null);
			return;
		}

		if(_rightLaserGun == null)
		{
			_rightLaserGun = new LaserGun(this, new FlxVector(FlxG.width - 150, this.height), 15, 25, 10);
			_guns.add(_rightLaserGun);
			flixel.plugin.MouseEventManager.add(_rightLaserGun, showLaserUpgrades, null, null, null);
			return;
		}	
	}

	private function addMissileLauncher(sprite:FlxSprite):Void
	{
		if(_leftMissileTurret == null)
		{
			_leftMissileTurret = new MissileTurret(this, new FlxVector(100, this.height), 250, 10);
			_guns.add(_leftMissileTurret);
			flixel.plugin.MouseEventManager.add(_leftMissileTurret, showMissileUpgrades, null, null, null);
			return;
		}

		if(_rightMissileTurret == null)
		{
			_rightMissileTurret = new MissileTurret(this, new FlxVector(FlxG.width - 100, this.height), 250, 10);
			_guns.add(_rightMissileTurret);
			flixel.plugin.MouseEventManager.add(_rightMissileTurret, showMissileUpgrades, null, null, null);
			return;
		}	
	}	

	override public function draw():Void
	{
		super.draw();
		_guns.draw();

		_flakCannonIcon.draw();
		_flakCannonIconText.draw();
			
		_missileLauncherIcon.draw();
		_missileLauncherIconText.draw();

		_laserGunIcon.draw();
		_laserGunIconText.draw();	

		if(_playState.subState != null)
		{
			_playState.subState.draw();	
		}
	}

	override public function update():Void 
	{
		super.update();
		_guns.update();
		shoot();

		updateIconTexts();
	}

	private function updateIconTexts():Void
	{
		//update icon texts
		var flakCount : Int = 0;
		if(_leftFlakGun != null)
			flakCount++;

		if(_rightFlakGun != null)
			flakCount++;	

		_flakCannonIconText.text = "" + flakCount + "/2";

		var launcherCount : Int = 0;
		if(_leftMissileTurret != null)
			launcherCount++;

		if(_rightMissileTurret != null)
			launcherCount++;

		_missileLauncherIconText.text = "" + launcherCount + "/2";

		var laserCount : Int = 0;
		if(_leftLaserGun != null)
			laserCount++;

		if(_rightLaserGun != null)
			laserCount++;

		_laserGunIconText.text = "" + laserCount + "/2";		
	}

	private function shoot() : Void
	{
		for(i in 0..._guns.length)
		{
			if(_guns.members[i].isLoaded())
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
	
	private function stampCircle(p:FlxPoint): Void
	{
		var imax : Int = 10;
		
		for (i in (-imax)...(imax))
		{
			for (j in (-imax) ... imax)
			{
				if (i * i + j * j < imax * imax)
				{
					var source:FlxSprite = new FlxSprite();
					source.makeGraphic(2, 2, FlxColorUtil.makeFromARGB(0.0, 255, 0, 0));
					
					//////// copy from stamp
					source.drawFrame();
					var bitmapData:BitmapData = source.framePixels;
					

					_flashPoint.x = Std.int(p.x + i) + region.startX;
					_flashPoint.y = Std.int(p.y - this.y+ j) + region.startY;
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
				}
			}
		}
	}
	
	public function ShotImpact(s:Projectile)
	{

		var decimate = _population  * FlxRandom.floatRanged( 0, 0.01) + 50;
		
		checkDead();
		stampCircle(new FlxPoint(s.x, s.y));
		FlxG.camera.flash(FlxColorUtil.makeFromARGB(0.75, 232, 239, 215),0.35);
		FlxG.camera.shake(0.0075, 0.35);
		_population -= decimate;
		_hitSound.pan = (s.x / FlxG.width * 2) - 1;
		_hitSound.play();
	}
	
	private function checkDead() : Void 
	{
		if (_population <= 0)
		{
			kill();
		}
	}
	
}