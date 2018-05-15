package menu;

import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import util.BitmapFont;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.Assets;

/**
 * ...
 * @author Victor Reynolds
 */
class MenuElement extends Sprite 
{
	public var xpos:Float = 0.5;
	public var ypos:Float = 0.5;
	public var size:Float = 1.0;
	
	public var textField:TextField;
	public var textFormat:TextFormat;
	public var bitmapFont:BitmapFont;

	public function new() 
	{
		super();
	}
	
	//TODO: 480 should not be hardcoded
	public function Update()
	{
		x = (Lib.application.window.width * xpos);
		y = (Lib.application.window.height * ypos);
		scaleX = scaleY = Lib.application.window.height / (480 / size);
	}
	
	public function AddText(str:String, fontName:String, fontSize:UInt, align:String)
	{
		var font:Font = Assets.getFont(fontName);
		
		textFormat = new TextFormat(font.fontName, 24, 0xaabb55, null, null, null, null, null, align);
		textField = new TextField();
		textField.defaultTextFormat = textFormat;
		textField.setTextFormat(textFormat);
		textField.embedFonts = true;
		textField.autoSize = align;
		
		textField.y = -textField.height / 2;
		if (align == TextFormatAlign.CENTER)
		{
			textField.x = -textField.width / 2;
		}
		addChild(textField);
	}
	
	public function AddBitmapText(str:String, bitmapName:String, multiLines:Bool = false, characterSpacing:UInt = 0, lineSpacing:UInt = 0, lineAlignment:String = "left", allowLowerCase:Bool = true)
	{
		bitmapFont = BitmapFont.Load(bitmapName);
		bitmapFont.setTextProperties(str, multiLines, characterSpacing, lineSpacing, lineAlignment, allowLowerCase);
		bitmapFont.x = -bitmapFont.width / 2;
		bitmapFont.y = -bitmapFont.height / 2;
		addChild(bitmapFont);
	}
}