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
	private var _city : City;

	public function new(string : String, city : City)
	{
		super();
		_labelText = string;
		_city = city;
	}

	public override function create() : Void
	{
		super.create();
		_background = new flixel.FlxSprite();
		_background.makeGraphic(Std.int(flixel.FlxG.width * 0.75), 400, flixel.util.FlxColorUtil.makeFromARGB(1.0, 64, 65, 66));
		_background.setPosition(Std.int(flixel.FlxG.width * 0.125), 100);
		_background.origin.set();
		_background.scrollFactor.set(0, 0);	

		_closeButton = new FlxButton(400, 400, "", close); 
		_closeButton.loadGraphic(AssetPaths.buttonClose__png, true, 48, 18); 
		_closeButton.scale.set(2, 2);
	
		_closeButton.animation.add('idle', [0]); 
		_closeButton.animation.add('hover', [1]); 
		_closeButton.onOver.callback = onOver; 
		_closeButton.onOut.callback = onOut; 
		_closeButton.visible = true;

		_label = new FlxText(Std.int(flixel.FlxG.width * (0.5 - 0.125)) + 50, 100, -1, _labelText, 16);

		add(_background);
		add(_label);
		add(_closeButton);		
	}

	public function loadPlusButton(button : FlxButton) : Void
	{
		button.loadGraphic(AssetPaths.buttonPlus__png, true, 18, 18); 
		button.scale.set(2, 2);	
	}

	public function onOver() : Void
	{

	}

	public function onOut() : Void
	{

	}

	public override function close() : Void
	{
		_city.continueMoneyTimer();
		super.close();
	}

	public override function draw() : Void
	{
		super.draw();
	}
}