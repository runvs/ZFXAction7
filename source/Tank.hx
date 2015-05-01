package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

/**
 * ...
 * @author 
 */
class Tank extends FlxSprite
{

	private var _bound:Bool;
	
	private var _ship : EnemyShip = null;

	private var _dir : FlxVector;	// r and phi, not x and y
	private var _bindTimer: Float;
	private var _rotationVelocity : Float;
	private var _distance: Float;
	
	public function new() 
	{
		super();
		this.makeGraphic(8, 8, FlxColorUtil.makeFromARGB(1, 220, 220, 220));
		this.origin.set(4,4);
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		_bound = false;
		this.angularVelocity = 45;
		_bindTimer = 0.75;
	}
	
	public override function update () :Void
	{
		super.update();
		if (_bound == false)
		{
			this.velocity = new FlxPoint(velocity.x, velocity.y + GameProperties.GetGravitationalAcceleration() * FlxG.elapsed);
		}
		else
		{
			if (_ship  == null)
			{
				_bound = false;
			}
			_dir = new FlxVector( _distance, _dir.y + _rotationVelocity  * FlxG.elapsed);
		
			SetPositionInOrbit();
		}
	}
	
	private function SetPositionInOrbit() : Void
	{
		var d :FlxVector = new FlxVector(Math.cos(Math.PI / 180 * _dir.y) * _dir.x, Math.sin(Math.PI / 180 * _dir.y) * _dir.x);
		this.setPosition(_ship.x + d.x, _ship.y + d.y);
	}
	
	
	public function Bind ( e: EnemyShip): Void
	{
		
		if (!_bound)
		{
			
			_bindTimer -= FlxG.elapsed;
			//trace (_bindTimer);
			if (_bindTimer <= 0)
			{
				trace("bind");
				_ship = e;
				_bound = true;
				
				// store velocity vector
				var v : FlxVector = new FlxVector(this.velocity.x, this.velocity.y);
				// reset velocity and acceleration to 0 (everything up frm now will be done by manually setting positions.
				FlxTween.tween(this.velocity, { x:0, y:0 }, 2.5);
				FlxTween.tween(this.acceleration, { x:0, y:0 }, 2.5);
				
				
				
				var d : FlxVector = new FlxVector( - e.x + this.x, - e.y  + this.y);
				//var angularVelocity: Float = (d.degrees - _dir.y ) / FlxG.elapsed;
				_dir = new FlxVector(d.length, d.degrees);
				
				var rad : FlxVector = new FlxVector(d.y, -d.x);
				
				var projv : FlxVector = new FlxVector(v.x, v.y);
				projv = projv.projectTo(rad);
				var angularVelocity: Float = projv.length;
				_distance = d.length;
				
				var c : Float = Math.acos(d.dotProduct(v) / d.length / v.length);
				trace (angularVelocity);
				if (c < Math.PI/2)
				{
					_rotationVelocity = - angularVelocity;
					FlxTween.tween(this, { _rotationVelocity: -45 }, 2.5, { ease:FlxEase.sineInOut } );
				}
				else
				{
					_rotationVelocity = angularVelocity;
					FlxTween.tween(this, { _rotationVelocity:45 }, 2.5, { ease:FlxEase.sineInOut});
				}
				FlxTween.tween(this , {_distance:100 }, 2.5,{ ease:FlxEase.sineInOut});
			}
			else
			{
				
			}
		}
		
	}
	
}