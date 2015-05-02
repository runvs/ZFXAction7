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
    public static function solve(a : Float, b : Float, c : Float) : FlxVector
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


