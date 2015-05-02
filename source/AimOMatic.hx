package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
import flixel.util.FlxVector;

/**
 * ...
 * @author 
 */
class AimOMatic 
{
  public static function aim2(shooterPosition : FlxVector, targetPosition : FlxVector, targetVelocity : FlxVector, projectileSpeed : Float) : FlxVector
  {
    //Much of this is geared towards reducing floating point precision errors
    var projectileSpeedSq : Float = projectileSpeed * projectileSpeed;

    var targetSpeedSq : Float = targetVelocity.lengthSquared; //doing this instead of self-multiply for maximum accuracy
    var targetSpeed : Float = Math.sqrt(targetSpeedSq);

    var targetToMuzzle : FlxVector = new FlxVector(shooterPosition.x - targetPosition.x, shooterPosition.y - targetPosition.y);
    var targetToMuzzleDistSq : Float = targetToMuzzle.lengthSquared; //doing this instead of self-multiply for maximum accuracy
    var targetToMuzzleDist : Float = Math.sqrt(targetToMuzzleDistSq);

    var targetToMuzzleDir : FlxVector = targetToMuzzle;
    targetToMuzzleDir = targetToMuzzleDir.normalize();

    var targetVelocityDir : FlxVector= targetVelocity;
    targetVelocityDir = targetVelocityDir.normalize();

    //Law of Cosines: a*a+ b*b - 2*a*b*cos(theta) = c*c
    //Quadratic formula: t = [ -b ± Sqrt( b*b - 4*a*c ) ] / (2*a)
    var cosTheta : Float = targetToMuzzleDir.dotProduct(targetVelocityDir);
    var a : Float = projectileSpeedSq - targetSpeedSq;
    var b : Float = 2.0 * targetToMuzzleDist * targetSpeed * cosTheta;
    var c : Float = -targetToMuzzleDistSq;

    var uglyNumber : Float = Math.sqrt(b * b - 4.0 * a * c);
    var t0 : Float = 0.5 * (-b + uglyNumber) / a;
    var t1 : Float = 0.5 * (-b - uglyNumber) / a;
    var t : Float = 0;
    //Assign the lowest positive time to t
    t = Math.min(t0, t1);
    if (t < 0)
    {
      t = Math.max(t0, t1);
    }

    //Vb = Vt - 0.5*Ab*t + [(Pti - Pbi) / t]
    var gravity : Float = 0;
    var projectileAcceleration : FlxVector = new FlxVector(gravity * 0, gravity * 1);
    var vx : Float = targetVelocity.x - (0.5 * projectileAcceleration.x * t) + (-targetToMuzzle.x / t);
    var vy : Float = targetVelocity.y - (0.5 * projectileAcceleration.y * t) + (-targetToMuzzle.y / t);
    //FOR CHECKING ONLY (valid only if gravity is 0)...
    //float calculatedprojectilespeed = Vb.magnitude;
    //bool projectilespeedmatchesexpectations = (projectileSpeed == calculatedprojectilespeed);
    //...FOR CHECKING ONLY
    trace(vx + ", " + vy);
    return new FlxVector(vx, vy);
  }

    public static function aim(shooterPosition : FlxVector, targetPosition : FlxVector, targetVelocity : FlxVector, projectileSpeed : Float) : FlxVector
    {
        var tx : Float = targetPosition.x - shooterPosition.x;
        var ty : Float = targetPosition.y - shooterPosition.y;
        var tvx : Float = targetVelocity.x;
        var tvy : Float = targetVelocity.y;

        var a : Float = tvx * tvx + tvy * tvy - projectileSpeed * projectileSpeed;
        var b : Float = 2 * (tvx * tx + tvy * ty);
        var c : Float = tx * tx + ty * ty;

        var ts = solve(a, b, c);
      
        var solution : FlxVector = null;

        if(ts != null)
        {
            var t0 : Float = ts.x;
            var t1 : Float = ts.y;

            var t : Float = Math.min(t0, t1);

            if(t < 0)
            {
                t = Math.max(t0, t1);
            }

            if(t > 0)
            {
                solution = new FlxVector(targetPosition.x + targetVelocity.x * t, targetPosition.y + targetVelocity.y * t);
            }
        }

        return solution;
    }
  
    //solve ax^2 + bx + c
    public static function solve(a : Float, b : Float, c : Float) 
    {
    
      var solution : flixel.util.FlxVector = null;
      if (Math.abs(a) < 1e-6) 
      {
          if (Math.abs(b) < 1e-6) 
          {
              if(Math.abs(c) < 1e-6)
              {
                  solution = new flixel.util.FlxVector(0, 0);
              } 
          } 
          else 
          { 
              solution = new flixel.util.FlxVector(-c/b, -c/b);
          }
      } 
      else 
      {
          var disc : Float = b*b - 4*a*c;
          if (disc >= 0) 
          {
              disc = Math.sqrt(disc);
              a = 2*a;
              solution = new flixel.util.FlxVector((-b-disc)/a, (-b+disc)/a);
          }
      }
      return solution;
    }    
}


