package ;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class MissileTurretUpgradeScreen extends UpdateScreen
{
	private var _missileTurret : MissileTurret;
	private var _improveProjectileSpeed : FlxButton;
	private var _improveRateOfFire : FlxButton;
	private var _projectileSpeed : flixel.text.FlxText;
	private var _rateOfFire : flixel.text.FlxText;

	public function new(missileTurret : MissileTurret)
	{
		super("MissileTurret Upgrades");
		_missileTurret = missileTurret;
	}

	public override function create()
	{
		super.create();
	
		_improveProjectileSpeed = new flixel.ui.FlxButton(500, 150, "+", improveProjectileSpeed);
		_improveRateOfFire = new flixel.ui.FlxButton(500, 250, "+", improveRateOfFire);
		_projectileSpeed = new flixel.text.FlxText(150, 150, -1, "", 16);
		_rateOfFire = new flixel.text.FlxText(150, 250, -1, "", 16);

		add(_improveProjectileSpeed);
		add(_improveRateOfFire);
		add(_projectileSpeed);
		add(_rateOfFire);

		updateStrings();
	}

	private function updateStrings():Void
	{
		_projectileSpeed.text = "Projectile Speed: 		" + _missileTurret._projectileSpeed;
		_rateOfFire.text = 	"Rate of Fire:			" + _missileTurret._rateOfFire;
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