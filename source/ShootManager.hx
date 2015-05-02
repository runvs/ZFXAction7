package ;

/**
 * @author 
 */

interface ShootManager 
{
	public function addEnemyShot(projectiles : flixel.group.FlxTypedGroup<Projectile>) : Void;
	public function addPlayerShot(projectiles: flixel.group.FlxTypedGroup<Projectile>) : Void;

	public function getEnemyShots() : flixel.group.FlxTypedGroup<Projectile>;
}