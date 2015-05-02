package ;

import flixel.FlxSprite;
/**
 * ...
 * @author 
 */
class Gun extends FlxSprite
{
	private var _owner : FlxSprite;

	public function new(owner : FlxSprite) 
	{
		super();
		_owner = owner;
	}
	
	public override function update() : Void 
	{
		super.update();		
	}

	public override function draw() : Void 
	{
		super.draw();
	}

	public function shoot(target : FlxSprite) : flixel.group.FlxTypedGroup<Projectile>
	{
		return null;
	}

	public function isLoaded() : Bool
	{
		return false;
	}

	public function reload() : Void
	{
		
	}

	public function getProjectileSpeed() : Float
	{
		return 0;
	}
}