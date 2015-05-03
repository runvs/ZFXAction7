package ;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class FlakUpdateScreen extends FlxState
{
	private var _flak : FlakGun;

	private var _background : FlxSprite;
	private var _border : FlxSprite;

	private var _improveAccuracy : FlxButton;
	private var _improveSpread : FlxButton;
	private var _improveProjectileSpeed : FlxButton;
	private var _improveNumberOfBullets : FlxButton;
	private var _closeButton : FlxButton;

	private var _accuracy : flixel.text.FlxText;
	private var _spread : flixel.text.FlxText;
	private var _projectileSpeed : flixel.text.FlxText;
	private var _numberOfBullets : flixel.text.FlxText;
	private var _label : flixel.text.FlxText;

	public var _visible : Bool;

	public function new()
	{
		super();
		
		_improveAccuracy = new flixel.ui.FlxButton(500, 150, "+", improveAccuracy);
		_improveSpread = new flixel.ui.FlxButton(500, 200, "+", improveSpread);
		_improveProjectileSpeed = new flixel.ui.FlxButton(500, 250, "+", improveProjectileSpeed);
		_improveNumberOfBullets = new flixel.ui.FlxButton(500, 300, "+", improveNumberOfBullets);
		_closeButton = new flixel.ui.FlxButton(500, 350, "close", hide);
		_background = new flixel.FlxSprite();
		_background.makeGraphic(600, 300, flixel.util.FlxColorUtil.makeFromARGB(1.0, 123, 42, 124));
		_background.setPosition(100, 100);
		_background.origin.set();
		_background.scrollFactor.set(0, 0);
	

		_label = new FlxText(250, 100, -1, "Flak Cannon Upgrades", 16);
		_accuracy = new flixel.text.FlxText(150, 150, -1, "", 16);
		_spread = new flixel.text.FlxText(150, 200, -1, "", 16);
		_projectileSpeed = new flixel.text.FlxText(150, 250, -1, "", 16);
		_numberOfBullets = new flixel.text.FlxText(150, 300, -1, "", 16);

		_visible = false;
	}

	public function hide():Void
	{
		_visible = false;
	}

	public function show(flak: FlakGun):Void
	{
		_visible = true;
		_flak = flak;

		updateStrings();
	}

	private function updateStrings():Void
	{
		_accuracy.text = 		"Accuracy:				" + _flak._accuracy;
		_spread.text = 			"Angular Spread:			" + _flak._angularSpread;
		_projectileSpeed.text = "Projectile Speed:		" + _flak._projectileSpeed;
		_numberOfBullets.text = "Bullets:					" + _flak._numberOfBullets;
	}

	public override function update():Void
	{
		super.update();

		_background.update();
		_improveAccuracy.update();
		_improveSpread.update();
		_improveProjectileSpeed.update();
		_improveNumberOfBullets.update();	
		_closeButton.update();
		_accuracy.update();
		_spread.update();
		_projectileSpeed.update();
		_numberOfBullets.update();
		_label.update();
	}

	public override function draw():Void
	{
		super.draw();

		_background.draw();
		_improveAccuracy.draw();
		_improveSpread.draw();
		_improveProjectileSpeed.draw();
		_improveNumberOfBullets.draw();
		_closeButton.draw();
		_accuracy.draw();
		_spread.draw();
		_projectileSpeed.draw();
		_numberOfBullets.draw();	
		_label.draw();
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