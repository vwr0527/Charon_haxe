package world;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author 
 */
class BackgroundElement extends Sprite 
{
	var sprite:Sprite;
	public var dist:Float;
	public var xpos:Float;
	public var ypos:Float;

	public function new() 
	{
		super();
		dist = 0;
		xpos = 0;
		ypos = 0;
	}
	
	public function UsePic(assetName:String, rot:Float = 0, scaling:Float = 1.0)
	{
		if (sprite != null)
		{
			removeChild(sprite);
			sprite = null;
		}
		try {
			var bmd:BitmapData = Assets.getBitmapData(assetName);
			var bmd2:BitmapData = new BitmapData(bmd.width, bmd.height);
			bmd2.threshold(bmd, bmd2.rect, new Point(0, 0), "==", 0xffff00ff, 0x00000000, 0xffffffff, true);
			
			var bitmap = new Bitmap(bmd2);
			sprite = new Sprite();
			sprite.addChild(bitmap);
			bitmap.x -= bitmap.width * 0.5;
			bitmap.y -= bitmap.height * 0.5;
			bitmap.smoothing = true;
			sprite.scaleY = sprite.scaleX = scaling;
			sprite.rotation = rot;
			addChild(sprite);
		} catch (msg:String) {
			trace(msg);
			return;
		}
	}
}