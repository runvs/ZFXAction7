package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
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
	
	private var _ammunition : Int;
	private var _ammunitionMax : Int;
	
	private var _ammunitionText1 : FlxText;
	private var _ammunitionText2 : FlxText;
	
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
		_ammunition = _ammunitionMax = 4;
		
		/// hud objects
		_ammunitionText1 = new FlxText(10, 10, 200, "", 12);
		_ammunitionText1.color = FlxColorUtil.makeFromARGB(0.85, 245, 245, 245);
		_ammunitionText2 = new FlxText(10, 10, 200, "", 12);
		_ammunitionText2.color = FlxColorUtil.makeFromARGB(0.45, 10, 10, 10);
		_ammunitionText2.offset.set( -2, -2);
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
	
	public override function draw () : Void 
	{
		super.draw();
	}
	
	public function drawHud () : Void 
	{
		_ammunitionText2.text = Std.string(_ammunition);
		_ammunitionText2.draw();
		_ammunitionText1.text = Std.string(_ammunition);
		_ammunitionText1.draw();
	}
	
	
	private function shoot(): Void 
	{
		if (_ammunition > 0)
		{
			var t : Tank  = new Tank(_shootManager);
			t.setPosition (this.x, this.y);
			var power : Float = (_shootTimer / GameProperties.GetShootTimer()) * 325 + 125;
			t.velocity = new FlxPoint(Math.cos(_targetAngle*Math.PI/180) * power, - Math.sin(_targetAngle*Math.PI/180) * power);
			_tankManager.SpawnTank(t);
			_ammunition--;
		}
	}
	
	public function refillAmmunition () : Void 
	{
		_ammunition++;
		if (_ammunition > _ammunitionMax )
		{
			_ammunition = _ammunitionMax;
		}
	}
}