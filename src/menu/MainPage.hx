package menu;

import flash.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Lib;
import openfl.Assets;

/**
 * ...
 * @author Victor Reynolds
 */
class MainPage extends MenuPage 
{
	var textField:TextField;
	var textPos = new Point(0.5, 0.25);
	var textSize = 2;
	
	public function new() 
	{
		super();
		
		textField = new TextField();
		var textFont = Assets.getFont("fonts/pirulen.ttf");
		var textFieldFormat = new TextFormat(textFont.fontName, 24, 0xaabb55, true, null, null, null, null, TextFormatAlign.CENTER);
		
		textField.defaultTextFormat = textFieldFormat;
		textField.setTextFormat(textFieldFormat);
		textField.embedFonts = true;
		
		textField.text = "Test";
		
		addChild(textField);
	}
	
	public override function Update()
	{
		super.Update();
		
		textField.scaleX = textField.scaleY = Lib.application.window.height / (720 / textSize);
		textField.x = (Lib.application.window.width * textPos.x) - (textField.width / 2);
		textField.y = (Lib.application.window.height * textPos.y) - (textField.height / 2);
	}
}