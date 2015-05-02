package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxVector;
import haxe.remoting.FlashJsConnection;
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

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_background = new FlxSprite();
		_background = _background.loadGraphic(AssetPaths.Background__png, false, 640, 480);
		//_background.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		_background.origin.set();
		_background.setPosition(0, 0);
		
		//var bmd : BitmapData = _background.getFlxFrameBitmapData();
		//bmd.applyFilter(bmd, new flash.geom.Rectangle(0, 0, 100, 100),  new flash.geom.Point(100, 100), new flash.filters.BlurFilter(20,20,9000));
		//_background.pixels = bmd;
		_city = new City(this);
		_player = new Player(this);
		
		
		
		
		_enemyList  = new FlxTypedGroup<EnemyShip>();
	
		_enemyList.add(SmallEnemyShip.spawn(this, new FlxVector(320, 100), 40));
		//_enemyList.add(MediumEnemyShip.spawn(this, new FlxVector(50, 10), 50));
		//_enemyList.add(LargeEnemyShip.spawn(this, new FlxVector(20, 180), 50));
		
		_tankList  = new FlxTypedGroup<Tank>();

		_enemyShotList = new FlxTypedGroup<Projectile>();
		_playerShotList = new FlxTypedGroup<Projectile>();	
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		_city.update();
		_enemyList.update();
		_enemyShotList.update();
		_tankList.update();
		_playerShotList.update();
		_tankList.forEachAlive(checkTankEnemyOverlap);
		_enemyShotList.forEachAlive(checkShotCityOverlap);
		_player.update();

		FlxG.collide(_playerShotList, _enemyShotList, shotCollision);

		_playerShotList.forEachAlive
		(
			function(playerShot:Projectile)
			{
				_enemyShotList.forEachAlive
				(
					function(enemyShot:Projectile)
					{
						//if(playerShot.collidesWith(enemyShot))
						//{
						//	enemyShot.kill();
						//	playerShot.hit();
						//}
					}
				);
			}
		);
	}	

	public function shotCollision(playerShot:Projectile, enemyShot:Projectile):Void
	{
		trace("shots hit!");
		playerShot.kill();
		enemyShot.kill();
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
	}
	
	/* INTERFACE TankManager */
	
	public function AddTank(T:Tank )  : Void
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
			trace ("checkShotCityOverlap overlap");
			_city.ShotImpact(s);
		}
	}
	
}