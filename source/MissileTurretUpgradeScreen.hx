package ;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class MissileTurretUpgradeScreen extends FlxState
{
	private var _missileTurret : MissileTurret;
	private var _background : FlxSprite;
	private var _border : FlxSprite;

	private var _improveProjectileSpeed : FlxButton;
	private var _improveRateOfFire : FlxButton;

	private var _closeButton : FlxButton;

	private var _projectileSpeed : flixel.text.FlxText;
	private var _rateOfFire : flixel.text.FlxText;
	private var _label : flixel.text.FlxText;

	public var _visible : Bool;


	public function new()
	{
		super();
	
		_improveProjectileSpeed = new flixel.ui.FlxButton(500, 150, "+", improveProjectileSpeed);
		_improveRateOfFire = new flixel.ui.FlxButton(500, 250, "+", improveRateOfFire);
		
		_closeButton = new flixel.ui.FlxButton(500, 350, "close", hide);
		_background = new flixel.FlxSprite();
		_background.makeGraphic(600, 300, flixel.util.FlxColorUtil.makeFromARGB(1.0, 123, 42, 124));
		_background.setPosition(100, 100);
		_background.origin.set();
		_background.scrollFactor.set(0, 0);
	

		_label = new FlxText(250, 100, -1, "MissileTurret Upgrades", 16);
		_projectileSpeed = new flixel.text.FlxText(150, 150, -1, "", 16);
		_rateOfFire = new flixel.text.FlxText(150, 250, -1, "", 16);

		_visible = false;
	}

	public function hide():Void
	{
		_visible = false;
	}

	public function show(missileTurret: MissileTurret):Void
	{
		_visible = true;
		_missileTurret = missileTurret;

		if(missileTurret != null)
		{
			updateStrings();	
		}
	}

	private function updateStrings():Void
	{
		_projectileSpeed.text = "Projectile Speed: 		" + _missileTurret._projectileSpeed;
		_rateOfFire.text = 	"Rate of Fire:			" + _missileTurret._rateOfFire;
	}

	public override function update():Void
	{
		super.update();

		_background.update();
		_improveProjectileSpeed.update();
		_improveRateOfFire.update();
		
		_closeButton.update();
		_projectileSpeed.update();
		_rateOfFire.update();

		_label.update();
	}

	public override function draw():Void
	{
		super.draw();
		
		_background.draw();

		_improveProjectileSpeed.draw();
		_improveRateOfFire.draw();

		_closeButton.draw();
		_projectileSpeed.draw();
		_rateOfFire.draw();
		_label.draw();
		
	}

	private function improveProjectileSpeed() : Void
	{
		if(_missileTurret._projectileSpeed > 0)
		{
			_missileTurret._projectileSpeed--;
			updateStrings();
		}
	}

	private function improveRateOfFire() : Void
	{
		_missileTurret._rateOfFire--;

		updateStrings();
	}		
}