package ;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVector;
import flixel.util.FlxTimer;

/**
 * Flaks are defined by
 *		"number of bullets" -> describes the number of bullets like shotguns 
 *		"accuracy" -> describes how accurate the flak cannons aim at their desired 
 						target
 *		"density"  -> how close the bullets explode to each other
 *				
 *		
 * @author 
 */
class MissileProjectile extends Projectile
{
	//private var _path : flixel.util.FlxPath;
	private var _engineTimer : flixel.util.FlxTimer;
	private var _target : flixel.FlxSprite;
	private var _projectileSpeed : Float;

	private var _missilePath : flixel.util.FlxPath;

	private var _engineStarted : Bool;
	private var _accelerating : Bool;
	private var _tracking : Bool;
	private var _explosion : FlxSprite;
	private var _exploded : Bool;
	private var _explodeSound : flixel.system.FlxSound;

	public function new(target : FlxSprite, engineStartTime : Float) 
	{
		super();
		//makeGraphic(3, 8, FlxColorUtil.makeFromARGB(1, 150, 150, 0));
		this.loadGraphic(AssetPaths.projectileRocket__png, false, 4, 8);
		this.scale.set(1.5, 1.5);
		this.updateHitbox();
		
		_target = target;

		//var power : Float = FlxRandom.floatRanged(-150, 150);
		var power = 200;
		
		var a  = FlxRandom.floatRanged(75, 115);
		
		this.velocity = new FlxPoint(Math.cos(a * Math.PI/180) * power, - Math.sin(a * Math.PI/180) * power);
		this.angularVelocity = 299;
		//this.offset.set(-25, -25);
		//FlxTween.tween(this.offset, { x:25, y:25 }, 1, { type:FlxTween.PINGPONG, ease:FlxEase.backInOut } );
		_engineTimer = new flixel.util.FlxTimer(engineStartTime, null, 1);
		_missilePath = new flixel.util.FlxPath();	
		_engineStarted = false;
		_projectileSpeed = 200;

		_exploded = false;
		
		// FlxSprite stuff
		_explosion = new FlxSprite();
		_explosion.loadGraphic(AssetPaths.explosionFlak__png, true, 32, 32);
		_explosion.animation.add("idle", [0], 30, true);
		_explosion.animation.add("explode", [1, 2, 3, 4, 5, 6, 7, 8], 23, false);
		_explosion.animation.play("idle");
		var s : Float = FlxRandom.floatRanged(0.5, 2);
		_explosion.scale.set(s,s);
		_explosion.updateHitbox();
		
		// FlxSound stuff
		_explodeSound = FlxG.sound.load(AssetPaths.explo1__mp3, 0.35);	
	}	

	public override function draw()
	{
		if (!_exploded)
		{
			super.draw();
		}
		_explosion.draw();
	}

	public override function update()
	{
		super.update();
		_engineTimer.update();
		_explosion.update();
		
		if(_target.alive == false)//für simon
		{
			explode();
			return;
		}

		if(_engineTimer.finished)
		{
			startEngine();

			if(_accelerating)
			{
				if(this.velocity.y < -90)
				{
					_tracking = true;
					_accelerating = false;
					trackTarget();
				}
			}

			if(_missilePath.finished)
			{
				explode();
			}
		}
		else
		{
			//trace("gravity!");
			this.velocity = new FlxPoint(velocity.x , velocity.y + GameProperties.GetGravitationalAcceleration() * FlxG.elapsed );
			this.velocity = new FlxPoint(velocity.x * 0.994, velocity.y * 0.994);		
		}
		
		//_path.update();
	}

	public override function explode() : Void
	{
		if (!_exploded )
		{
			_exploded = true;
			_explosion.setPosition(x, y);
			_explosion.animation.play("explode", true);
			this.width = _explosion.width;		// try to trick the collisions
			this.height = _explosion.height;
			var t : flixel.util.FlxTimer = new flixel.util.FlxTimer(9.0 / 20.0, function(t:FlxTimer) { this.kill(); } );
			
			_explodeSound.pan = (x / FlxG.width * 2) - 1;
			
			_explodeSound.play();
		}
	}

	private function startEngine() : Void
	{
		if(!_engineStarted)
		{
			_engineStarted = true;
			_accelerating = true;

			this.acceleration.set(0, -100);
			var currentSpeed : Float = new FlxVector(this.velocity.x, this.velocity.y).length;
			var targetSpeed : Float = _projectileSpeed;

			var deltaT : Float = (targetSpeed - currentSpeed)/Math.abs(this.acceleration.y); //time to get to the projectile speed
			
			var target : FlxVector = AimOMatic.aim(new FlxVector(this.x, this.y), new FlxVector(_target.x, _target.y), new FlxVector(_target.velocity.x, _target.velocity.y), _projectileSpeed);
			var targetAngle : Float = target.degreesBetween(new FlxVector(0, -1)); //angle to the target 
			this.angularVelocity = 0;
			FlxTween.tween(this, {angle: -targetAngle +90}, deltaT, {ease:FlxEase.sineInOut});
			//FlxTween.tween(this, {angularVelocity:0}, 1, {ease:FlxEase.sineInOut});
		}		
	}

	private function trackTarget() : Void
	{
		var target : FlxVector = AimOMatic.aim(new FlxVector(this.x, this.y), new FlxVector(_target.x, _target.y), new FlxVector(_target.velocity.x, _target.velocity.y), _projectileSpeed);
		var nodes : Array<flixel.util.FlxPoint> = new Array<FlxPoint>();
		nodes.push(new FlxPoint(target.x, target.y));
		_missilePath.start(this, nodes, _projectileSpeed, flixel.util.FlxPath.FORWARD, true);		
	}
}