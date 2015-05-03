package ;
import flixel.util.FlxVector;

/**
 * ...
 * @author 
 */
class GameProperties
{

	
	public static function GetScaleFactor() : Float { return 2.5; };
	public static function GetPlayerTurnAngle():Float { return 10; };
	public static function GetGravitationalAcceleration() : Float { return 100; };
	public static function GetShootTimer () : Float { return 1.75; };
	public static function GetSmallEnemyShipHealth() : Float { return 100; };
	
	public static function GetEnemySpawnerExponent() : Float { return 1.9; };
	public static function GetEnemySpawnerMaxTime () : Float { return 9.5; };
	
	public static function GetInitialPopulation() : Float { return 6000; };
public static function GetIncreaseDifficultyTimer() : Float { return 14; };
	
}