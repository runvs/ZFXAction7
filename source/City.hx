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
	private var _money : Int;
	private var _moneyIcon : FlxSprite;
	private var _moneyNumberDisplay : NumberDisplay;

	private var _moneyindicator : FlxSprite;
	private var _moneymarker: FlxSprite;
	private var _moneybar: FlxSprite;
	private var _moneyTimer : flixel.util.FlxTimer;

	public var _guns : flixel.group.FlxTypedGroup<Gun>;
	private var _shootManager : ShootManager;
	private var _playState : PlayState;

	private var _population : Float;
	private var _populationText : NumberDisplay;
	private var _populationicon : FlxSprite;

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
	private var _lastTime : Float;

	public function new(shootManager : ShootManager, playState : PlayState) 
	{
		super();
		_lastTime = 0;
		_playState = playState;

		this.loadGraphic(AssetPaths.city__png, false, 640, 163);
		//this.offset.set(0, 163);
		this.setPosition(0, FlxG.height - 32 - this.height);

		_flakCannonIcon = new FlxSprite();
		_flakCannonIcon.loadGraphic(AssetPaths.turretFlakBase__png, false, 16, 16);
		_flakCannonIcon.scale.set(3, 3);
		_flakCannonIcon.updateHitbox();
		_flakCannonIcon.x = FlxG.width - 60;
		_flakCannonIcon.y = FlxG.height - 0.75 * FlxG.height - 32;

		_flakCannonIconText = new FlxText(FlxG.width - 55, FlxG.height - 0.73 * FlxG.height, -1, "0/2", 16);

		_missileLauncherIcon = new FlxSprite();
		_missileLauncherIcon.loadGraphic(AssetPaths.turretMissileLauncher__png, false, 16, 16, true);
		_missileLauncherIcon.scale.set(3, 3);
		_missileLauncherIcon.x = FlxG.width - 60;
		_missileLauncherIcon.y = FlxG.height - 0.65 * FlxG.height -32;
		_missileLauncherIcon.updateHitbox();

		_missileLauncherIconText = new FlxText(FlxG.width - 55, FlxG.height - 0.63 * FlxG.height, -1, "0/2", 16);

		_laserGunIcon = new FlxSprite();
		_laserGunIcon.loadGraphic(AssetPaths.turretLaser__png, false, 16, 16);
		_laserGunIcon.scale.set(3, 3);
		_laserGunIcon.updateHitbox();
		_laserGunIcon.x = FlxG.width - 60;
		_laserGunIcon.y = FlxG.height - 0.55 * FlxG.height -32;

		_laserGunIconText = new FlxText(FlxG.width - 55, FlxG.height - 0.53 * FlxG.height, -1, "0/2", 16);

		_guns = new flixel.group.FlxTypedGroup<Gun>();
		_leftFlakGun = new FlakGun(this, new FlxVector(50, this.height-16), 2, 60, 15, 200, 3);	
		_rightFlakGun = new FlakGun(this, new FlxVector(FlxG.width - 50, this.height-16), 2, 60, 15, 200, 3);
	
		//we have flak guns by default
		_guns.add(_leftFlakGun);
		_guns.add(_rightFlakGun);

		_shootManager = shootManager;	
		_population = GameProperties.GetInitialPopulation();
		
		// HUD
		_populationicon = new FlxSprite();
		_populationicon.loadGraphic(AssetPaths.person__png, false, 16, 16);
		_populationicon.setPosition(FlxG.width - 32, 10);
		_populationicon.scale.set(2, 2);
		_populationText = new NumberDisplay(true);

		flixel.plugin.MouseEventManager.add(_leftFlakGun, showFlakUpgrades, true, true, false);
		flixel.plugin.MouseEventManager.add(_rightFlakGun, showFlakUpgrades, true, true, false);

		flixel.plugin.MouseEventManager.add(_laserGunIcon, addLaserGun, true, true, false);
		flixel.plugin.MouseEventManager.add(_missileLauncherIcon, addMissileLauncher, true, true, false);
		
		// Sound 
		_hitSound = new FlxSound();
		_hitSound = FlxG.sound.load(AssetPaths.cityexplo__mp3, 0.9, false);

		_moneyindicator = new FlxSprite();
		_moneyindicator.makeGraphic(8, 96, FlxColorUtil.makeFromARGB(1.0, 200, 50, 50));
		_moneyindicator.origin.set(4, 96);
		_moneyindicator.setPosition(FlxG.width - 40, FlxG.height - 150 );
		
		_moneyTimer = new flixel.util.FlxTimer(GameProperties.GetMoneyTimer(), increaseMoney, 0);
		_moneymarker = new FlxSprite();
		_moneymarker.makeGraphic(12, 2, FlxColorUtil.makeFromARGB(1.0, 200, 50, 50));
		_moneymarker.origin.set(0, 0);
		
		_moneybar = new FlxSprite();
		_moneybar.makeGraphic(2, 96, FlxColorUtil.makeFromARGB(1.0, 200, 50, 50));
		_moneybar.origin.set(1, 96);
		_moneybar.setPosition(FlxG.width - 40 + 12, FlxG.height - 96 - 32 );	

		_moneyIcon = new FlxSprite();
		_moneyIcon.loadGraphic(AssetPaths.moneyIcon__png, false, 16, 16);
		_moneyIcon.setPosition(FlxG.width - 32, 45);
		_moneyIcon.scale.set(2, 2);
		_moneyNumberDisplay = new NumberDisplay(true);		
	}

	public function increaseMoney(timer:flixel.util.FlxTimer) : Void
	{
		_money++;
	}

	public function decreaseMoney(amount: Int) : Bool
	{
		if(_money < amount)
		{
			return false;
		}
		else
		{
			_money -= amount;
			return true;
		}
	}

	public function showFlakUpgrades(sprite:FlxSprite)
	{
		var spriteAsFlak : FlakGun = cast sprite;
		pauseMoneyTimer();
		_playState.openSubState(new FlakUpdateScreen(spriteAsFlak, this));
	}

	public function showLaserUpgrades(sprite:FlxSprite)
	{
		var spriteAsLaser : LaserGun = cast sprite;
		pauseMoneyTimer();
		_playState.openSubState(new LaserUpdateScreen(spriteAsLaser, this));
	}

	public function showMissileUpgrades(sprite:FlxSprite)
	{
		var spriteAsMissileLauncher : MissileTurret = cast sprite;
		pauseMoneyTimer();
		_playState.openSubState(new MissileTurretUpgradeScreen(spriteAsMissileLauncher, this));
	}	

	private function addLaserGun(sprite:FlxSprite):Void
	{
		if(_leftLaserGun == null)
		{
			if(decreaseMoney(1))
			{
				_leftLaserGun = new LaserGun(this, new FlxVector(150, this.height), 15, 25, 8);
				_guns.add(_leftLaserGun);
				flixel.plugin.MouseEventManager.add(_leftLaserGun, showLaserUpgrades, null, null, null);
				return;				
			}
		}

		if(_rightLaserGun == null)
		{
			if(decreaseMoney(1))
			{
				_rightLaserGun = new LaserGun(this, new FlxVector(FlxG.width - 150, this.height), 15, 25, 8);
				_guns.add(_rightLaserGun);
				flixel.plugin.MouseEventManager.add(_rightLaserGun, showLaserUpgrades, null, null, null);
				return;				
			}
		}	
	}

	private function addMissileLauncher(sprite:FlxSprite):Void
	{
		if(_leftMissileTurret == null)
		{
			if(decreaseMoney(1))
			{
				_leftMissileTurret = new MissileTurret(this, new FlxVector(100, this.height-16), 250, 10);
				_guns.add(_leftMissileTurret);
				flixel.plugin.MouseEventManager.add(_leftMissileTurret, showMissileUpgrades, null, null, null);
				return;				
			}
		}

		if(_rightMissileTurret == null)
		{
			if(decreaseMoney(1))
			{
				_rightMissileTurret = new MissileTurret(this, new FlxVector(FlxG.width - 100, this.height-16), 250, 10);
				_guns.add(_rightMissileTurret);
				flixel.plugin.MouseEventManager.add(_rightMissileTurret, showMissileUpgrades, null, null, null);
				return;				
			}
		}	
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
				var target : FlxSprite = null;

				if(_guns.members[i].prefersCloseTarget())
				{
					target = lookForClosestTarget(_guns.members[i]);
				}
				else if(_guns.members[i].prefersFarTarget())
				{
					//trace("far!");
					target = lookForFarthestTarget(_guns.members[i]);
				}

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
	
	private function lookForClosestTarget(gun : Gun) : flixel.FlxSprite
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

	private function lookForFarthestTarget(gun : Gun) : flixel.FlxSprite
	{
		var projectile:Projectile = null;

		_shootManager.getEnemyShots().forEachAlive
		(		
			function(shot:Projectile) 
			{ 
				if(projectile == null)
				{
					projectile = shot;
				}
				else
				{
					//is it closer in x?
					if(Math.abs(shot.x - gun.x) < Math.abs(projectile.x - gun.x))
					{
						if(shot.y < projectile.y)
						{
							projectile = shot;
						}
					}
				}
			}
		);

		return projectile;
	}
	
	
	public function drawHud () : Void 
	{
		_populationText.drawSingleNumber(Std.int(_population), new FlxPoint(FlxG.width - 110, 10));
		_populationicon.draw();

		_moneyIcon.draw();
		_moneyNumberDisplay.drawSingleNumber(_money, new FlxPoint(FlxG.width - 110, 40));
		
		var val : Float =  _moneyTimer.elapsedTime / GameProperties.GetMoneyTimer();
		if (val < 0 ) val = 0;
		
		_moneyindicator.scale.set(1, val * 3);
		_moneyindicator.alpha = val * 0.75 + 0.25;
		_moneyindicator.draw();

		_moneymarker.setPosition(_moneyindicator.x - 2, FlxG.height - 48);
		_moneymarker.draw();
		_moneymarker.setPosition(_moneyindicator.x - 2, FlxG.height - 350);
		_moneymarker.draw();	
		
				_flakCannonIcon.draw();
		_flakCannonIconText.draw();
			
		_missileLauncherIcon.draw();
		_missileLauncherIconText.draw();

		_laserGunIcon.draw();
		_laserGunIconText.draw();	
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
		FlxG.camera.flash(FlxColorUtil.makeFromARGB(0.75, 232, 239, 215),0.2);
		FlxG.camera.shake(0.0075, 0.2);
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

	public function continueMoneyTimer() : Void
	{
		_moneyTimer.active = true;
	}
	
	public function pauseMoneyTimer() : Void
	{
		_moneyTimer.active = false;
	}
}