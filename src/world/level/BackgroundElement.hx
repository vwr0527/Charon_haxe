package world.level;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author 
 */
class BackgroundElement extends Sprite 
{
	var sprite:Sprite;
	var outline:Shape;
	
	public var dist:Float;
	public var xpos:Float;
	public var ypos:Float;
	public var size:Float;

	public function new() 
	{
		super();
		dist = 0;
		xpos = 0;
		ypos = 0;
		size = 1;
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
			
			outline = new Shape();
			outline.graphics.beginFill(0xffffff);
			outline.graphics.drawRect(0, 0, bitmap.width, bitmap.height);
			sprite.addChild(outline);
			outline.x -= bitmap.width / 2;
			outline.y -= bitmap.height / 2;
			outline.visible = false;
			
		} catch (msg:String) {
			trace(msg);
			return;
		}
	}
	
	var pulseTime = 0.0;
	
	public function ShowOutline()
	{
		outline.visible = true;
		outline.alpha = (Math.sin(pulseTime) + 2) / 8;
		pulseTime += 0.1;
	}
	
	public function HideOutline()
	{
		outline.visible = false;
	}
	
	public function Update()
	{
	}
}