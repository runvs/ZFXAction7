package ;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class UpdateScreen extends flixel.FlxSubState
{
	private var _background : FlxSprite;
	private var _closeButton : FlxButton;
	private var _label : flixel.text.FlxText;
	private var _labelText : String;

	public function new(string : String)
	{
		super();
		_labelText = string;
	}

	public override function create() : Void
	{
		super.create();
		_background = new flixel.FlxSprite();
		_background.makeGraphic(600, 300, flixel.util.FlxColorUtil.makeFromARGB(1.0, 123, 42, 124));
		_background.setPosition(100, 100);
		_background.origin.set();
		_background.scrollFactor.set(0, 0);	

		// _closeButton = new flixel.ui.FlxButton(500, 350, "close", close);
		// _closeButton.loadGraphic(AssetPaths.button_blue__png, true, 18, 18);//, ?Unique:Bool, ?Key:String)

		_closeButton = new FlxButton(500, 350, "close", close); 
		_closeButton.loadGraphic(AssetPaths.button_blue__png, true, 18, 18); 
		_closeButton.scale.set(5, 1);
		_closeButton.animation.add('idle', [0]); 
		_closeButton.animation.add('hover', [1]); 
		_closeButton.onOver.callback = onOver; 
		_closeButton.onOut.callback = onOut; 
		_closeButton.visible = true;

		_label = new FlxText(250, 100, -1, _labelText, 16);

		add(_background);
		add(_label);
		add(_closeButton);		
	}

	public function onOver() : Void
	{

	}

	public function onOut() : Void
	{

	}
	public override function draw() : Void
	{
		super.draw();
	}
}