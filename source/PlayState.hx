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
	
	private var _enemyShotList : FlxTypedGroup<Shot>;
	private var _playerShotList : FlxTypedGroup<Shot>;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_background = new FlxSprite();
		_background.makeGraphic(320, 240, FlxColorUtil.makeFromARGB(1, 123, 123, 123));
		_background.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		_background.origin.set();
		_background.setPosition(0, 0);
		
		_city = new City();
		_player = new Player(this);
		
		_enemyList  = new FlxTypedGroup<EnemyShip>();
	
		_enemyList.add(SmallEnemyShip.spawn(this, new FlxVector(320, 100), 40));
		//_enemyList.add(MediumEnemyShip.spawn(this, new FlxVector(50, 10), 50));
		//_enemyList.add(LargeEnemyShip.spawn(this, new FlxVector(20, 180), 50));
		
		_tankList  = new FlxTypedGroup<Tank>();

		_enemyShotList = new FlxTypedGroup<Shot>();
		_playerShotList = new FlxTypedGroup<Shot>();	
		
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
		_tankList.update();
		
		_tankList.forEachAlive(checkTankEnemyOverlap);
		
		_player.update();
	}	
	
	override public function draw () : Void 
	{
		_background.draw();
		_city.draw();
		_enemyList.draw();
		_player.draw();
		_tankList.draw();
		_enemyShotList.draw();
	}
	
	/* INTERFACE TankManager */
	
	public function AddTank(T:Tank )  : Void
	{
		_tankList.add(T);
	}

	/* INTERFACE ShootManager */

	public function addEnemyShot(shot : Shot) : Void
	{
		_enemyShotList.add(shot);
	}

	public function addPlayerShot(shot : Shot) : Void
	{
		_playerShotList.add(shot);
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
	}}