package menu;

import openfl.display.Sprite;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Assets;
import openfl.Lib;
import util.BitmapFont;

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
	
	public function AddText(str:String, fontName:String, fontSize:UInt = 12, fontColor:Int = 0xffffff, align:String = "left")
	{
		var font:Font = Assets.getFont(fontName);
		
		textFormat = new TextFormat(font.fontName, fontSize, fontColor, null, null, null, null, null, align);
		textField = new TextField();
		textField.defaultTextFormat = textFormat;
		textField.setTextFormat(textFormat);
		textField.embedFonts = true;
		textField.autoSize = align;
		textField.text = str;
		
		addChild(textField);
	}
	
	public function AddBitmapText(str:String, bitmapName:String, lineAlignment:String = "left", characterSpacing:UInt = 0, lineSpacing:UInt = 0)
	{
		bitmapFont = BitmapFont.Load(bitmapName);
		bitmapFont.setTextProperties(str, true, characterSpacing, lineSpacing, lineAlignment, true);
		bitmapFont.x = -bitmapFont.width / 2;
		bitmapFont.y = -bitmapFont.height / 2;
		addChild(bitmapFont);
	}
	
	public function Smooth(smoothing:Bool)
	{
		if (bitmapFont != null) bitmapFont.setSmoothing(smoothing);
	}
}