package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class Player extends FlxSprite
{

	private var _targetAngle: Float;
	private var _lastAngleIncrement : Float;
	private var _tankManager : TankManager;
	private var _shootTimer : Float;
	private var _shootManager : ShootManager;
	
	public function new(tm: TankManager, sm : ShootManager) 
	{
		super();
		_tankManager = tm;
		_shootManager = sm;
		this.makeGraphic(16, 16, FlxColorUtil.makeFromARGB(1.0, 20, 200, 20));
		this.origin.set(8, 16);
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		
		this.setPosition(320, 480-32);
		_targetAngle = 90;
		_lastAngleIncrement = 0;
		_shootTimer  = 0;
	}
	
	
	override public function update():Void 
	{
		super.update();
		
		if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			_lastAngleIncrement -= GameProperties.GetPlayerTurnAngle() * FlxG.elapsed;
		}
		else if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			_lastAngleIncrement += GameProperties.GetPlayerTurnAngle() * FlxG.elapsed;
		}
		else
		{ 
			_lastAngleIncrement = 0;
		}
		
		_targetAngle += _lastAngleIncrement*0.5;
		if (_targetAngle > 180)
		{
			_targetAngle = 180;
			_lastAngleIncrement = 0;
		}
		if (_targetAngle < 0)
		{
			_targetAngle = 0;
			_lastAngleIncrement = 0;
		}
		
		if (FlxG.keys.anyPressed(["Space"]))
		{
			_shootTimer  += FlxG.elapsed;
		}
		if ((FlxG.keys.anyJustReleased(["SPACE"]) && _shootTimer != 0) || _shootTimer  > GameProperties.GetShootTimer() )
		{
			shoot();
			_shootTimer = 0;
		}
		this.angle = 90 - _targetAngle;
	}
	
	private function shoot(): Void 
	{
		//trace ("shoot");
		var t : Tank  = new Tank(_shootManager);
		t.setPosition (this.x, this.y);
		var power : Float = (_shootTimer / GameProperties.GetShootTimer()) * 325 + 125;
		t.velocity = new FlxPoint(Math.cos(_targetAngle*Math.PI/180) * power, - Math.sin(_targetAngle*Math.PI/180) * power);
		_tankManager.AddTank(t);
	}
	
}