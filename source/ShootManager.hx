package ;

/**
 * @author 
 */

interface ShootManager 
{
	public function addEnemyShot(s : Shot) : Void;
	public function addPlayerShot(s : Shot) : Void;

	public function getEnemyShots() : flixel.group.FlxTypedGroup<Shot>;
}