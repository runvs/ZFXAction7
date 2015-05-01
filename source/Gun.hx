package ;

import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class Gun extends FlxSprite
{

	public function new() 
	{
		super();
	}
	
	public override function update() : Void 
	{
		super.update();		
	}

	public override function draw() : Void 
	{
		super.draw();
	}

	public function shoot() : Shot
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
}