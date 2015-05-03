package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;
import haxe.macro.Expr.Position;
import haxe.remoting.FlashJsConnection;
import haxe.Timer;
import openfl.display.BitmapData;
import openfl.filters.BitmapFilter;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState implements TankManager implements ShootManager
{
	private var _background : FlxSprite;
	
	private var _city : City;
	private var _player : Player;
	private var _enemyList : FlxTypedGroup<EnemyShip>;
	private var _tankList : FlxTypedGroup<Tank>;
	
	private var _enemyShotList : FlxTypedGroup<Projectile>;
	private var _playerShotList : FlxTypedGroup<Projectile>;
	
	private var _clouds : CloudLayer;
	
	private var _overlay : FlxSprite;
	
	private var _enemySpawnTimer : Float;
	private var _maxEnemies : Float;
	
	
	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_background = new FlxSprite();
		_background = _background.loadGraphic(AssetPaths.Background__png, false, 640, 1000);
		//_background.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		_background.origin.set();
		_background.setPosition(0, 0);
		
		//var bmd : BitmapData = _background.getFlxFrameBitmapData();
		//bmd.applyFilter(bmd, new flash.geom.Rectangle(0, 0, 100, 100),  new flash.geom.Point(100, 100), new flash.filters.BlurFilter(20,20,9000));
		//_background.pixels = bmd;
		_city = new City(this);
		_player = new Player(this, this);
		
		//trace (FlxG.width);
		
		_maxEnemies = 1;
		_enemySpawnTimer = 0;
		
		var t : FlxTimer = new FlxTimer(15, function (t:FlxTimer) { increaseDifficulty(); } ); 
		
		_enemyList  = new FlxTypedGroup<EnemyShip>();
		spawnEnemyShip();
		//_enemyList.add(SmallEnemyShip.spawn(this, new FlxVector(320, 700), 40));
		//_enemyList.add(MediumEnemyShip.spawn(this, new FlxVector(50, 10), 50));
		//_enemyList.add(LargeEnemyShip.spawn(this, new FlxVector(20, 180), 50));
		
		_tankList  = new FlxTypedGroup<Tank>();

		_enemyShotList = new FlxTypedGroup<Projectile>();
		_playerShotList = new FlxTypedGroup<Projectile>();	
		
		_clouds  = new CloudLayer();
		
		
		_overlay = new FlxSprite();
		_overlay.makeGraphic(FlxG.width, FlxG.height, FlxColorUtil.makeFromARGB(1, 0, 0, 0));
		_overlay.origin.set();
		_overlay.x = _overlay.y = 0;
		_overlay.alpha = 1.0;
		
		FlxTween.tween(_overlay, { alpha:0 }, 1);
		
		super.create();
	}
	
	
	private function increaseDifficulty() : Void 
	{
		_maxEnemies++;
	}
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	
	 private function cleanUp():Void
    {
		// delete unneeded shots
		_enemyShotList.forEach(function(p:Projectile) : Void { if (p.y > FlxG.height || p.x < -10 || p.x > FlxG.width+10) p.kill(); } );
        {
			// clean list from dead shots
            var newEnemyShotList:FlxTypedGroup<Projectile> = new FlxTypedGroup<Projectile>();
            _enemyShotList.forEach(function(s:Projectile) { if (s.alive) { newEnemyShotList.add(s); } else { s.destroy(); } } );
            _enemyShotList = newEnemyShotList;
        }
    }
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		cleanUp();
		_clouds.update();
		_city.update();
		_enemyList.update();
		
		_enemyShotList.update();
		_tankList.update();
		_playerShotList.update();
		_tankList.forEachAlive(checkTankEnemyOverlap);
		_tankList.forEachAlive(checkTankRefill);
		_enemyShotList.forEachAlive(checkShotCityOverlap);
		_player.update();
		_overlay.update();
		
		_enemySpawnTimer += FlxG.elapsed;
		
		if (_enemySpawnTimer >= GetSpawnTime())
		{	
			spawnEnemyShip();
			
			_enemySpawnTimer = 0;
		}
		
		FlxG.overlap(_playerShotList, _enemyShotList, shotShotCollision); //laguna asked for it
		FlxG.overlap(_playerShotList, _enemyList, shotEnemyCollision); 
		
		
		checkGameOver();
		
	}	

	private function checkTankRefill ( t: Tank) : Void 
	{
		if (t.GetMode() == TankMode.Parachute)
		{
			if (t.y > FlxG.height - 40)
			{
				t.kill();
				_player.refillAmmunition();
			}
		}
	}
	
	private function GetEnemyStrength() : Float 
	{
		var str : Float = 0;
		_enemyList.forEach(function (s:EnemyShip):Void
		{
			str += s.GetShipStrength();
		});
		return str;
	}
	
	private function GetSpawnTime() : Float
	{
		var currentEnemies = GetEnemyStrength();
		var exponent = GameProperties.GetEnemySpawnerExponent();
		var ret = (Math.pow(currentEnemies / _maxEnemies, exponent)) * GameProperties.GetEnemySpawnerMaxTime();
		return ret;
	}
	
	private function shotShotCollision(playerShot:Projectile, enemyShot:Projectile):Void
	{
		//trace("shots hit!");
		//if (FlxG.pixelPerfectOverlap(playerShot, enemyShot, 1))
		{
			if (playerShot.alive)
			{
				playerShot.explode();
				enemyShot.kill();
			}
		}
	}
	
	private function shotEnemyCollision(playerShot:Projectile, enemy:EnemyShip):Void
	{
		//trace("enemyhit!");
		//if (FlxG.pixelPerfectOverlap(playerShot, enemy))	// no need for ppoverlap, as the player WANTS to destroy the enemy
		{
			//trace("enemyhit ppo!");	
			enemy.takeDamage(playerShot);
			playerShot.kill();
			//enemy.kill();
			
		}
	}
	
	override public function draw () : Void 
	{
		_background.draw();
		_city.draw();
		_enemyList.draw();
		_player.draw();
		_tankList.draw();
		_enemyShotList.draw();
		_playerShotList.draw();
		
		_clouds.draw();
		
		// HUD STUFF
		_player.drawHud();
		_city.drawHud();
		_overlay.draw();
		
	}
	
	/* INTERFACE TankManager */
	
	public function SpawnTank(T:Tank)  : Void
	{
		_tankList.add(T);
	}

	/* INTERFACE ShootManager */

	public function addEnemyShot(projectiles : flixel.group.FlxTypedGroup<Projectile>) : Void
	{
		for(i in 0...projectiles.length)
		{
			_enemyShotList.add(projectiles.members[i]);	
		}
	}

	public function getEnemyShots() : FlxTypedGroup<Projectile>
	{
		return _enemyShotList;
	}

	public function addPlayerShot(projectiles : flixel.group.FlxTypedGroup<Projectile>) : Void
	{
		for(i in 0...projectiles.length)
		{
			_playerShotList.add(projectiles.members[i]);	
		}	
	}

	private function checkTankEnemyOverlap(t: Tank)
	{
		_enemyList.forEachAlive(
		function(e:EnemyShip) 
		{ 
				var dist : FlxVector = new FlxVector(e.x - t.x, e.y - t.y);
				if (dist.length < 100)
				{
					
					t.Bind(e);
				}
		}
		);
	}

	private function checkShotCityOverlap(s:Projectile)
	{
		//trace ("checkShotCityOverlap");
		if (FlxG.overlap(s, _city))
		{
			//trace ("checkShotCityOverlap overlap");
			if (FlxG.pixelPerfectOverlap(s, _city, 1))
			{
				_city.ShotImpact(s);
				s.kill();
			}
			
		}
	}
	
	function checkGameOver():Void 
	{
		if (!_city.alive)
		{
			FlxTween.tween(_overlay, { alpha:1.0 }, 0.7);
			var t : FlxTimer = new FlxTimer(0.75, function (t:FlxTimer) : Void { FlxG.switchState(new MenuState()); } );
		}
	}
	
	function spawnEnemyShip():Void 
	{
		
		var p : FlxPoint = new FlxPoint(FlxRandom.floatRanged(0, FlxG.width), FlxRandom.floatRanged(0, FlxG.height / 2));
		var v : FlxPoint = new FlxPoint(FlxRandom.floatRanged( -20, 20), 0);
		//trace (v);
		var r : Int = FlxRandom.intRanged(0, 2);
		//if (r == 0)
		{
			
			_enemyList.add(SmallEnemyShip.spawn(this, p, v.x, v.y, 1));
			//_enemyl
		}
		//else if (r == 1)
		//{
			//e = new MediumEnemyShip(this);
		//}
		//else if (r == 2)
		//{
			//e = new LargeEnemyShip(this);
		//}
		
	}
	
}