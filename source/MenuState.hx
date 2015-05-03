package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var _logo: FlxSprite;
	private var _playButton: FlxButton;
	private var _description: FlxText;
	private var _about : FlxText;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		_playButton = new FlxButton(0, 0, "Play", startGame);
		_playButton.scale.set(2, 2);

		_description = new FlxText(0, 0, -1, "Shoot your tanks into an orbit around\nenemy spaceships to kill them.\n\nBuy new Towers by clicking on the sidebar.\n\nTo upgrade your defense, click the Towers.\nEverything costs 1.", 24);
		_description.alignment = "center";
		
		_about = new FlxText(0, 0, -1, "A game by runvs\n thunraz: graphics\n laguna: code, sound\n morkar: code\n\n created for zfxaction7\n\nvisit us at http://runvs.io", 18);
		_about.alignment = "center";
		_about.color = flixel.util.FlxColorUtil.makeFromARGB(1, 128, 129, 130);
		flixel.util.FlxSpriteUtil.screenCenter(_about, true, false);
		_about.y = FlxG.height * 0.75;
		_description.y = FlxG.height * 0.25;
		flixel.util.FlxSpriteUtil.screenCenter(_playButton);
		flixel.util.FlxSpriteUtil.screenCenter(_description, true, false);
		add(_description);
		add(_playButton);
		add(_about);

		_logo = new FlxSprite();
		_logo.loadGraphic(AssetPaths.logo__png, false, 84, 29);
		_logo.scale.set(5, 5);
		_logo.y = 0.125 * FlxG.height;
		add(_logo);
		flixel.util.FlxSpriteUtil.screenCenter(_logo, true, false);

		FlxG.sound.playMusic(AssetPaths.zfxaction7ost__mp3,0.85);	
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	public override function draw():Void
	{
		this.bgColor = flixel.util.FlxColorUtil.makeFromARGB(1, 50, 60, 57);
		super.draw();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
	
	private function startGame():Void
	{
		FlxG.switchState(new PlayState());
	}
}