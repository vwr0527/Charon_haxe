/**
 * FlxBitmapFont
 * 
 * Note the package is set-up such that it expects you to place this file into the org/flixel/ structure
 * 
 * @author Richard Davey, Photon Storm, http://www.photonstorm.com
 * @version 1 - 20th May 2010
 * 
 * Ported to Haxe OpenFL by Victor Reynolds
 */

package util;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Sprite;
import openfl.Assets;

class BitmapFont extends Sprite
{
	/**
	 * Alignment of the text when multiLine = true. Set to FlxBitmapFont.ALIGN_LEFT (default), FlxBitmapFont.ALIGN_RIGHT or FlxBitmapFont.ALIGN_CENTER.
	 */
	public var align:String = "left";
	
	/**
	 * If set to true all carriage-returns in text will form new lines (see align). If false the font will only contain one single line of text (the default)
	 */
	public var multiLine:Bool = false;
	
	/**
	 * Automatically convert any text to upper case. Lots of old bitmap fonts only contain upper-case characters, so the default is true.
	 */
	public var autoUpperCase:Bool = true;
	
	/**
	 * Adds horizontal spacing between each character of the font, in pixels. Default is 0.
	 */
	public var customSpacingX:UInt = 0;
	
	/**
	 * Adds vertical spacing between each line of multi-line text, set in pixels. Default is 0.
	 */
	public var customSpacingY:UInt = 0;
	
	private var _text:String;
	
	/**
	 * Align each line of multi-line text to the left.
	 */
	public static inline var ALIGN_LEFT:String = "left";
	
	/**
	 * Align each line of multi-line text to the right.
	 */
	public static inline var ALIGN_RIGHT:String = "right";
	
	/**
	 * Align each line of multi-line text in the center.
	 */
	public static inline var ALIGN_CENTER:String = "center";
	
	/**
	 * Text Set 1 = !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
	 * Text Set 2 =  !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ
	 * Text Set 3 = ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 
	 * Text Set 4 = ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789
	 * Text Set 5 = ABCDEFGHIJKLMNOPQRSTUVWXYZ.,/() '!?-*:0123456789
	 * Text Set 6 = ABCDEFGHIJKLMNOPQRSTUVWXYZ!?:;0123456789\"(),-.' 
	 * Text Set 7 = AGMSY+:4BHNTZ!;5CIOU.?06DJPV,(17EKQW\")28FLRX-'39
	 * Text Set 8 = 0123456789 .ABCDEFGHIJKLMNOPQRSTUVWXYZ
	 * Text Set 9 = ABCDEFGHIJKLMNOPQRSTUVWXYZ()-0123456789.:,'\"?!
	 * Text Set 10 = ABCDEFGHIJKLMNOPQRSTUVWXYZ
	 * Text Set 11 = ABCDEFGHIJKLMNOPQRSTUVWXYZ.,\"-+!?()':;0123456789
	 */
	
	/**
	 * Internval values. All set in the constructor. They should not be changed after that point.
	 */
	private var fontSet:BitmapData;
	private var offsetX:UInt;
	private var offsetY:UInt;
	private var characterWidth:UInt;
	private var characterHeight:UInt;
	private var characterSpacingX:UInt;
	private var characterSpacingY:UInt;
	private var characterPerRow:UInt;
	private var grabData:Array<Rectangle>;
	
	/**
	 * Constructs and returns a BitmapFont using a text file. Looks for a text file with the same name as the image.
	 * 
	 * @param	fontName		The path and file name to the font image file.
	 * @return	A BitmapFont constructed using the settings in a text file of the same name.
	 */
	public static function Load(fileName:String):BitmapFont
	{
		var textName:String = fileName.substring(0, fileName.lastIndexOf(".")) + ".txt";
		
		var params:Array<String> = (Assets.getText(textName)).split("\n");
		
		var bmd:BitmapData = Assets.getBitmapData(fileName);
		var bmd2:BitmapData = new BitmapData(bmd.width, bmd.height);
		if (params[8].length > 10) params[8] = params[8].substr(0, params[8].length - 1); // only necessary because of a neko bug with parseInt not liking hex ending in '\n'
		bmd2.threshold(bmd, bmd2.rect, new Point(0, 0), "==", Std.parseInt(params[8]), 0x00000000, 0xffffffff, true);
		return new BitmapFont(bmd2, Std.parseInt(params[0]), Std.parseInt(params[1]), params[2], Std.parseInt(params[3]), Std.parseInt(params[4]), Std.parseInt(params[5]), Std.parseInt(params[6]), Std.parseInt(params[7]));
	}
	
	/**
	 * Loads 'font' and prepares it for use by future calls to .text
	 * 
	 * @param	font		The font set graphic class (as defined by your embed)
	 * @param	width		The width of each character in the font set.
	 * @param	height		The height of each character in the font set.
	 * @param	chars		The characters used in the font set, in display order. You can use the TEXT_SET consts for common font set arrangements.
	 * @param	charsPerRow	The number of characters per row in the font set.
	 * @param	xSpacing	If the characters in the font set have horizontal spacing between them set the required amount here.
	 * @param	ySpacing	If the characters in the font set have vertical spacing between them set the required amount here
	 * @param	xOffset		If the font set doesn't start at the top left of the given image, specify the X coordinate offset here.
	 * @param	yOffset		If the font set doesn't start at the top left of the given image, specify the Y coordinate offset here.
	 */
	public function new(bitmapData:BitmapData, width:UInt, height:UInt, chars:String, charsPerRow:UInt, xSpacing:UInt = 0, ySpacing:UInt = 0, xOffset:UInt = 0, yOffset:UInt = 0)
	{
		super();
		//	Take a copy of the font for internal use
		fontSet = bitmapData;
		
		characterWidth = width;
		characterHeight = height;
		characterSpacingX = xSpacing;
		characterSpacingY = ySpacing;
		characterPerRow = charsPerRow;
		offsetX = xOffset;
		offsetY = yOffset;
		
		grabData = new Array();
		
		//	Now generate our rects for faster copyPixels later on
		var currentX = offsetX;
		var currentY = offsetY;
		var r:UInt = 0;
		
		for (c in 0...chars.length)
		{
			//	The rect is hooked to the ASCII value of the character
			grabData[chars.charCodeAt(c)] = new Rectangle(currentX, currentY, characterWidth, characterHeight);
			
			r++;
			
			if (r == characterPerRow)
			{
				r = 0;
				currentX = offsetX;
				currentY += characterHeight + characterSpacingY;
			}
			else
			{
				currentX += characterWidth + characterSpacingX;
			}
		}
	}
	
	/**
	 * Set this value to update the text in this sprite. Carriage returns are automatically stripped out if multiLine is false. Text is converted to upper case if autoUpperCase is true.
	 * 
	 * @return	void
	 */ 
	public function setText(content:String)
	{
		// TODO? We could do a smarter update here, only changing the characters that are different,
		// but there is a trade-off between the processing cost of string comparison / building vs. just copying a few pixels anyway.
		
		if (autoUpperCase)
		{
			_text = content.toUpperCase();
		}
		else
		{
			_text = content;
		}
		
		removeUnsupportedCharacters(multiLine);
		
		buildBitmapFontText();
	}
	
	public function getText():String
	{
		return _text;
	}
	
	/**
	 * A helper function that quickly sets lots of variables at once, and then updates the text.
	 * 
	 * @param	content				The text of this sprite
	 * @param	multiLines			Set to true if you want to support carriage-returns in the text and create a multi-line sprite instead of a single line (default is false).
	 * @param	characterSpacing	To add horizontal spacing between each character specify the amount in pixels (default 0).
	 * @param	lineSpacing			To add vertical spacing between each line of text, set the amount in pixels (default 0).
	 * @param	lineAlignment		Align each line of multi-line text. Set to FlxBitmapFont.ALIGN_LEFT (default), FlxBitmapFont.ALIGN_RIGHT or FlxBitmapFont.ALIGN_CENTER.
	 * @param	allowLowerCase		Lots of bitmap font sets only include upper-case characters, if yours needs to support lower case then set this to true.
	 */
	public function setTextProperties(content:String, multiLines:Bool = false, characterSpacing:UInt = 0, lineSpacing:UInt = 0, lineAlignment:String = "left", allowLowerCase:Bool = false)
	{
		customSpacingX = characterSpacing;
		customSpacingY = lineSpacing;
		align = lineAlignment;
		multiLine = multiLines;
		
		if (allowLowerCase)
		{
			autoUpperCase = false;
		}
		else
		{
			autoUpperCase = true;
		}
		
		setText(content);
	}
	
	/**
	 * Updates the BitmapData of the Sprite with the text
	 * 
	 * @return	void
	 */
	private function buildBitmapFontText()
	{
		var temp:BitmapData;
		
		if (multiLine)
		{
			var lines:Array<String> = _text.split("\n");
			
			var cx:UInt = 0;
			var cy:UInt = 0;
		
			temp = new BitmapData(getLongestLine() * (characterWidth + customSpacingX), (lines.length * (characterHeight + customSpacingY)) - customSpacingY, true, 0xf);
			
			//	Loop through each line of text
			for (i in 0...lines.length)
			{
				//	This line of text is held in lines[i] - need to work out the alignment
				switch (align)
				{
					case BitmapFont.ALIGN_LEFT:
						cx = 0;
						
					case BitmapFont.ALIGN_RIGHT:
						cx = temp.width - (lines[i].length * (characterWidth + customSpacingX));
						
					case BitmapFont.ALIGN_CENTER:
						cx = cast (temp.width / 2) - ((lines[i].length * (characterWidth + customSpacingX)) / 2);
						cx += cast customSpacingX / 2;
				}
				
				pasteLine(temp, lines[i], cx, cy, customSpacingX);
				
				cy += characterHeight + customSpacingY;
			}
		}
		else
		{
			temp = new BitmapData(_text.length * (characterWidth + customSpacingX), characterHeight, true, 0xf);
		
			pasteLine(temp, _text, 0, 0, customSpacingX);
		}
		
		var result:Bitmap = new Bitmap(temp);
		result.smoothing = true;
		
		addChild(result);
	}
	
	/**
	 * Returns a single character from the font set as an FlxsSprite.
	 * 
	 * @param	char	The character you wish to have returned.
	 * 
	 * @return	An <code>FlxSprite</code> containing a single character from the font set.
	 */
	public function getCharacter(char:String):Bitmap
	{
		var output:Bitmap = new Bitmap();
		
		var temp:BitmapData = new BitmapData(characterWidth, characterHeight, true, 0xf);

		if (char.charCodeAt(0) != 32)
		{
			temp.copyPixels(fontSet, grabData[char.charCodeAt(0)], new Point(0, 0));
		}
		
		output.bitmapData = temp;
		
		return output;
	}
	
	/**
	 * Internal function that takes a single line of text (2nd parameter) and pastes it into the BitmapData at the given coordinates.
	 * Used by getLine and getMultiLine
	 * 
	 * @param	output			The BitmapData that the text will be drawn onto
	 * @param	line			The single line of text to paste
	 * @param	x				The x coordinate
	 * @param	y
	 * @param	customSpacingX
	 */
	private function pasteLine(output:BitmapData, line:String, x:UInt = 0, y:UInt = 0, customSpacingX:UInt = 0)
	{
		for (c in 0...line.length)
		{
			//	If it's a space then there is no point copying, so leave a blank space
			if (line.charAt(c) == " ")
			{
				x += characterWidth + customSpacingX;
			}
			else
			{
				//	If the character doesn't exist in the font then we don't want a blank space, we just want to skip it
				if (grabData[line.charCodeAt(c)] != null)
				{
					output.copyPixels(fontSet, grabData[line.charCodeAt(c)], new Point(x, y));
					x += characterWidth + customSpacingX;
				}
			}
		}
	}
	
	/**
	 * Works out the longest line of text in _text and returns its length
	 * 
	 * @return	A value
	 */
	private function getLongestLine():UInt
	{
		var longestLine:Int = 0;
		
		if (_text.length > 0)
		{
			var lines:Array<String> = _text.split("\n");
			
			for (i in 0...lines.length)
			{
				if (lines[i].length > longestLine)
				{
					longestLine = lines[i].length;
				}
			}
		}
		
		return longestLine;
	}
	
	/**
	 * Internal helper function that removes all unsupported characters from the _text String, leaving only characters contained in the font set.
	 * 
	 * @param	stripCR		Should it strip carriage returns as well? (default = true)
	 * 
	 * @return	A clean version of the string
	 */
	private function removeUnsupportedCharacters(stripCR:Bool = true):String
	{
		var newString:String = "";
		
		for (c in 0..._text.length)
		{
			if (grabData[_text.charCodeAt(c)] != null || _text.charCodeAt(c) == 32 || (stripCR == false && _text.charAt(c) == "\n"))
			{
				newString += _text.charAt(c);
			}
		}
		
		return newString;
	}
	
}
