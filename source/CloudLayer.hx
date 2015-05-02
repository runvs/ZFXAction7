package ;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author 
 */
class CloudLayer extends FlxSpriteGroup
{

	
	public function new() 
	{
		super();
		
		var c1 : FlxSprite = new FlxSprite();
		c1 = c1.loadGraphic(AssetPaths.Cloud1__png, false, 245, 88);
		add (c1);
		c1.setPosition( -500, 679);
		FlxTween.tween(c1, { x: 500}, 30, {type:FlxTween.PINGPONG});
		
		var c2 : FlxSprite = new FlxSprite();
		c2 = c2.loadGraphic(AssetPaths.Cloud2__png, false, 380, 100);
		add (c2);
		c2.setPosition( 500, 743);
		FlxTween.tween(c2, { x: -500}, 30 , {type:FlxTween.PINGPONG});
		
		var c3 : FlxSprite = new FlxSprite();
		c3 = c3.loadGraphic(AssetPaths.Cloud3__png, false, 447, 241);
		add (c3);
		c3.setPosition( 320, 522);
		
		FlxTween.tween(c3.offset, { x: -500}, 30 , {type:FlxTween.PINGPONG});
		
		var c4 : FlxSprite = new FlxSprite();
		c4 = c4.loadGraphic(AssetPaths.Cloud4__png, false, 473, 182);
		add (c4);
		c4.setPosition( 320, 522);
		FlxTween.tween(c4, { x: -500}, 30 , {type:FlxTween.PINGPONG});
		
		
		var c5 : FlxSprite = new FlxSprite();
		c5 = c5.loadGraphic(AssetPaths.Cloud5__png, false, 418, 99);
		add (c5);
		c5.setPosition( 320, 780);
		FlxTween.tween(c5, { x: -500}, 30 , {type:FlxTween.PINGPONG});
		
		
		
	}
	
}