package ;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class LaserUpdateScreen extends UpdateScreen
{
	private var _laser : LaserGun;
	
	private var _border : FlxSprite;

	private var _improveAccuracy : FlxButton;
	private var _improveSpread : FlxButton;
	private var _improveRateOfFire : FlxButton;

	private var _accuracy : flixel.text.FlxText;
	private var _spread : flixel.text.FlxText;
	private var _rateOfFire : flixel.text.FlxText;


	public function new(laserGun : LaserGun)
	{
		super("Laser Upgrades");
		_laser = laserGun;
	}

	public override function create()
	{
		super.create();
		
		_improveAccuracy = new flixel.ui.FlxButton(500, 150, "+", improveAccuracy);
		_improveSpread = new flixel.ui.FlxButton(500, 200, "+", improveSpread);
		_improveRateOfFire = new flixel.ui.FlxButton(500, 250, "+", improveRateOfFire);

		_accuracy = new flixel.text.FlxText(150, 150, -1, "", 16);
		_spread = new flixel.text.FlxText(150, 200, -1, "", 16);
		_rateOfFire = new flixel.text.FlxText(150, 250, -1, "", 16);

		add(_accuracy);
		add(_spread);
		add(_rateOfFire);

		add(_improveAccuracy);
		add(_improveSpread);
		add(_improveRateOfFire);
		updateStrings();
	}

	private function updateStrings():Void
	{
		_accuracy.text = 		"Accuracy:				" + _laser._accuracy;
		_spread.text = 			"Angular Spread:			" + _laser._angularSpread;
		_rateOfFire.text = 		"Rate of Fire:			" + _laser._rateOfFire;
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