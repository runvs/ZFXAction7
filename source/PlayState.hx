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
class PlayState extends FlxState
{
	
	
	private var _background : FlxSprite;
	
	private var _city : City;
	private var _player : Player;
	private var _enemyList : FlxTypedGroup<EnemyShip>;
	
	
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
		_player = new Player();
		
		_enemyList  = new FlxTypedGroup<EnemyShip>();
	
		_enemyList.add(SmallEnemyShip.spawn(new FlxVector(100, 100), 50));
		_enemyList.add(MediumEnemyShip.spawn(new FlxVector(50, 10), 50));
		_enemyList.add(LargeEnemyShip.spawn(new FlxVector(20, 180), 50));
		
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
		_player.update();
	}	
	
	override public function draw () : Void 
	{
		_background.draw();
		_city.draw();
		_enemyList.draw();
		_player.draw();
	}
}