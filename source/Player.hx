package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;

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
	
	private var _ammunitionText : NumberDisplay;
	
	private var _flumpsound : FlxSound;
	private var _refillammoTimer : FlxTimer;
	private var _refillSound : FlxSound;
	
	private var _shootindicator : FlxSprite;
	private var _shootmarker: FlxSprite;
	private var _shootbar: FlxSprite;
	
	
	public function new(tm: TankManager, sm : ShootManager) 
	{
		super();
		_tankManager = tm;
		_shootManager = sm;
		this.loadGraphic(AssetPaths.catapult__png, true, 32, 16);
		this.animation.add("idle", [0]);
		this.animation.add("shoot", [1, 2, 3, 3, 2, 3, 3, 0], 15, false);
		this.animation.play("idle");
		this.origin.set(16, 16);
		this.scale.set(2, 2);
		
		
		this.setPosition(320, FlxG.height-48);
		_targetAngle = 90;
		_lastAngleIncrement = 0;
		_shootTimer  = 0;
		_ammunition = _ammunitionMax = 4;
		 
	
		_refillammoTimer = new FlxTimer(2, function ( t:FlxTimer) : Void {   refillAmmunition(); }, 0);
		
		/// hud objects
		_ammunitionText = new NumberDisplay(true);
		
		_shootindicator = new FlxSprite();
		_shootindicator.makeGraphic(8, 96, FlxColorUtil.makeFromARGB(1.0, 200, 50, 50));
		_shootindicator.origin.set(4, 96);
		_shootindicator.setPosition(320 + 40, FlxG.height - 96 - 32 );
		
		
		_shootmarker = new FlxSprite();
		_shootmarker.makeGraphic(12, 2, FlxColorUtil.makeFromARGB(1.0, 200, 50, 50));
		_shootmarker.origin.set(0, 0);
		
		_shootbar = new FlxSprite();
		_shootbar.makeGraphic(2, 96, FlxColorUtil.makeFromARGB(1.0, 200, 50, 50));
		_shootbar.origin.set(1, 96);
		_shootbar.setPosition(320 + 40+12, FlxG.height - 96 - 32 );
		
		// sound
		_flumpsound = new FlxSound();
		_flumpsound = FlxG.sound.load(AssetPaths.flump__mp3);
		_refillSound  = new FlxSound();
		_refillSound = FlxG.sound.load(AssetPaths.bip__mp3, 0.25);
	}
	
	
	override public function update():Void 
	{
		super.update();
		_shootindicator.update();
		
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
		_ammunitionText.drawSingleNumber(_ammunition, new FlxPoint(10, 10));
		
		var val : Float = _shootTimer / GameProperties.GetShootTimer() ;
		if (val < 0 ) val = 0;
		if (val > GameProperties.GetShootTimer()) val = GameProperties.GetShootTimer();
		_shootindicator.scale.set(1, val);
		_shootindicator.alpha = val * 0.75 + 0.25;
		_shootindicator.draw();
		_shootmarker.setPosition(320 + 40, FlxG.height - 32);
		_shootmarker.draw();
		_shootmarker.setPosition( 320 + 40, FlxG.height - 32- 96 - 2);
		_shootmarker.draw();
		_shootbar.draw();
		
	}
	
	
	private function shoot(): Void 
	{
		if (_ammunition > 0)
		{
			this.animation.play("shoot");
			var t : Tank  = new Tank(_shootManager);
			t.setPosition (this.x, this.y);
			var power : Float = ((_shootTimer / GameProperties.GetShootTimer()) * 325 + 125) * 1.5;
			t.velocity = new FlxPoint(Math.cos(_targetAngle*Math.PI/180) * power, - Math.sin(_targetAngle*Math.PI/180) * power);
			_tankManager.SpawnTank(t);
			_ammunition--;
			_flumpsound.play();
		}
	}
	
	public function refillAmmunition () : Void 
	{
		_ammunition++;
		
		if (_ammunition > _ammunitionMax )
		{
			_ammunition = _ammunitionMax;
		}	
		else
		{
			_refillSound.play();
		}
	}
}