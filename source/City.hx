package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
import openfl.display.BitmapData;

/**
 * ...
 * @author 
 */
class City extends FlxSprite
{

	private var _guns : flixel.group.FlxTypedGroup<Gun>;
	private var _shootManager : ShootManager;

	public function new(shootManager : ShootManager) 
	{
		super();
		this.makeGraphic(320, 16, FlxColorUtil.makeFromARGB(1, 20, 20, 200));
		this.scale.set(GameProperties.GetScaleFactor(), GameProperties.GetScaleFactor());
		this.origin.set(0,0);
		this.setPosition(0, 480 - 32);
		this.updateHitbox();

		_guns = new flixel.group.FlxTypedGroup<Gun>();
		_guns.add(new FlakGun(this, 3, 45, 50));
		_shootManager = shootManager;	
	}

	override public function update():Void 
	{
		super.update();
		_guns.update();
		shoot();
	}

	private function shoot() : Void
	{
		for(i in 0..._guns.length)
		{
			if(_guns.members[i].isLoaded())
			{
				//yay, we can fire guns! lets look for a target... 
				var target : flixel.util.FlxVector = lookForTarget(_guns.members[i]);
				//no idea how i can set relative positions.. so ill work around
				var shot : Shot = _guns.members[i].shoot(target);
				shot.x = 320;
				shot.y = 240;
				_shootManager.addPlayerShot(shot);
			}
		}
	}	
	
	private function lookForTarget(gun : Gun) : flixel.util.FlxVector
	{
		return new flixel.util.FlxVector(320, 75);
	}
	
	public function ShotImpact(s:Shot)
	{
		var source:FlxSprite = new FlxSprite();
		source.makeGraphic(10, 10, FlxColorUtil.makeFromARGB(0.0, 255, 0, 0));
		
		//////// copy from stamp
		source.drawFrame();
		var bitmapData:BitmapData = source.framePixels;
		

		_flashPoint.x = Std.int(s.x/2) + region.startX;
		_flashPoint.y = Std.int(s.y - this.y) + region.startY;
		_flashRect2.width = bitmapData.width;
		_flashRect2.height = bitmapData.height;
		cachedGraphics.bitmap.copyPixels(bitmapData, _flashRect2, _flashPoint, null, null, false);
		_flashRect2.width = cachedGraphics.bitmap.width;
		_flashRect2.height = cachedGraphics.bitmap.height;
		
		resetFrameBitmapDatas();
		
		#if FLX_RENDER_BLIT
		dirty = true;
		calcFrame();
		#end
		//////// end copy from stamp
		//trace (Std.int(s.x));
		//this.pixels.
		s.kill();
	}
}