package ;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class LaserUpdateScreen extends FlxState
{
	private var _laser : LaserGun;
	private var _background : FlxSprite;
	private var _border : FlxSprite;

	private var _improveAccuracy : FlxButton;
	private var _improveSpread : FlxButton;
	private var _improveRateOfFire : FlxButton;

	private var _closeButton : FlxButton;

	private var _accuracy : flixel.text.FlxText;
	private var _spread : flixel.text.FlxText;
	private var _rateOfFire : flixel.text.FlxText;
	private var _label : flixel.text.FlxText;

	public var _visible : Bool;


	public function new()
	{
		super();
	
		_improveAccuracy = new flixel.ui.FlxButton(500, 150, "+", improveAccuracy);
		_improveSpread = new flixel.ui.FlxButton(500, 200, "+", improveSpread);
		_improveRateOfFire = new flixel.ui.FlxButton(500, 250, "+", improveRateOfFire);
		
		_closeButton = new flixel.ui.FlxButton(500, 350, "close", hide);
		_background = new flixel.FlxSprite();
		_background.makeGraphic(600, 300, flixel.util.FlxColorUtil.makeFromARGB(1.0, 123, 42, 124));
		_background.setPosition(100, 100);
		_background.origin.set();
		_background.scrollFactor.set(0, 0);
	

		_label = new FlxText(250, 100, -1, "Laser Upgrades", 16);
		_accuracy = new flixel.text.FlxText(150, 150, -1, "", 16);
		_spread = new flixel.text.FlxText(150, 200, -1, "", 16);
		_rateOfFire = new flixel.text.FlxText(150, 250, -1, "", 16);

		_visible = false;
	}

	public function hide():Void
	{
		_visible = false;
	}

	public function show(laser: LaserGun):Void
	{
		_visible = true;
		_laser = laser;

		if(_laser != null)
		{
			updateStrings();	
		}
	}

	private function updateStrings():Void
	{
		_accuracy.text = 		"Accuracy:				" + _laser._accuracy;
		_spread.text = 			"Angular Spread:			" + _laser._angularSpread;
		_rateOfFire.text = 		"Rate of Fire:			" + _laser._rateOfFire;
	}

	public override function update():Void
	{
		super.update();

		_background.update();
		_improveAccuracy.update();
		_improveSpread.update();
		_improveRateOfFire.update();
		
		_closeButton.update();
		_accuracy.update();
		_spread.update();
		_rateOfFire.update();

		_label.update();
	}

	public override function draw():Void
	{
		super.draw();
		
		_background.draw();

		_improveAccuracy.draw();
		_improveSpread.draw();
		_improveRateOfFire.draw();

		_closeButton.draw();
		_accuracy.draw();
		_spread.draw();
		_rateOfFire.draw();
		_label.draw();
		
	}

	private function improveAccuracy() : Void
	{
		if(_laser._accuracy > 0)
		{
			_laser._accuracy--;
			updateStrings();
		}
	}

	private function improveSpread() : Void
	{
		if(_laser._angularSpread > 0)
		{
			_laser._angularSpread--;
			updateStrings();			
		}
	}	

	private function improveRateOfFire() : Void
	{
		_laser._rateOfFire--;

		updateStrings();
	}		
}