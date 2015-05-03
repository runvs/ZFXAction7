package ;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class FlakUpdateScreen extends UpdateScreen
{
	private var _flak : FlakGun;

	private var _improveAccuracy : FlxButton;
	private var _improveSpread : FlxButton;
	private var _improveProjectileSpeed : FlxButton;
	private var _improveNumberOfBullets : FlxButton;

	private var _accuracy : flixel.text.FlxText;
	private var _spread : flixel.text.FlxText;
	private var _projectileSpeed : flixel.text.FlxText;
	private var _numberOfBullets : flixel.text.FlxText;

	public function new(flak : FlakGun)
	{
		super("FlakGun Upgrades");
		_flak = flak;
	}

	public override function create() : Void
	{
		super.create();
		
		_improveAccuracy = new flixel.ui.FlxButton(Std.int(flixel.FlxG.width * (0.75-0.125)), 150, "", improveAccuracy);
		_improveSpread = new flixel.ui.FlxButton(Std.int(flixel.FlxG.width * (0.75-0.125)), 200, "", improveSpread);
		_improveProjectileSpeed = new flixel.ui.FlxButton(Std.int(flixel.FlxG.width * (0.75-0.125)), 250, "", improveProjectileSpeed);
		_improveNumberOfBullets = new flixel.ui.FlxButton(Std.int(flixel.FlxG.width * (0.75-0.125)), 300, "", improveNumberOfBullets);
		
		loadPlusButton(_improveAccuracy);
		loadPlusButton(_improveSpread);
		loadPlusButton(_improveProjectileSpeed);
		loadPlusButton(_improveNumberOfBullets);

		_accuracy = new flixel.text.FlxText(Std.int(flixel.FlxG.width * 0.25), 150, -1, "", 16);
		_spread = new flixel.text.FlxText(Std.int(flixel.FlxG.width * 0.25), 200, -1, "", 16);
		_projectileSpeed = new flixel.text.FlxText(Std.int(flixel.FlxG.width * 0.25), 250, -1, "", 16);
		_numberOfBullets = new flixel.text.FlxText(Std.int(flixel.FlxG.width * 0.25), 300, -1, "", 16);

		add(_improveAccuracy);
		add(_improveSpread);
		add(_improveProjectileSpeed);
		add(_improveNumberOfBullets);

		add(_accuracy);
		add(_spread);
		add(_projectileSpeed);
		add(_numberOfBullets);

		updateStrings();
	}

	private function updateStrings():Void
	{
		_accuracy.text = 		"Accuracy:				" + _flak._accuracy;
		_spread.text = 			"Angular Spread:			" + _flak._angularSpread;
		_projectileSpeed.text = "Projectile Speed:		" + _flak._projectileSpeed;
		_numberOfBullets.text = "Bullets:					" + _flak._numberOfBullets;
	}

	private function improveAccuracy() : Void
	{
		if(_flak._accuracy > 0)
		{
			_flak._accuracy--;
			updateStrings();
		}
	}

	private function improveSpread() : Void
	{
		if(_flak._angularSpread > 0)
		{
			_flak._angularSpread--;
			updateStrings();			
		}
	}	

	private function improveProjectileSpeed() : Void
	{
		_flak._projectileSpeed++;

		updateStrings();
	}

	private function improveNumberOfBullets() : Void
	{
		_flak._numberOfBullets++;

		updateStrings();
	}		
}