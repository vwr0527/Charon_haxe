package world;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.Assets;
import openfl.utils.Function;

/**
 * ...
 * @author Victor Reynolds
 */
class Shot extends Entity 
{

	public function new() 
	{
		super();
		
		var bmd:BitmapData = openfl.Assets.getBitmapData("img/shot2.png");
		var bmd2:BitmapData = new BitmapData(bmd.width, bmd.height);
		bmd2.threshold(bmd, bmd2.rect, new Point(0, 0), "==", 0xff000000, 0x00000000, 0xffffffff, true);
		
		var bitmap = new Bitmap(bmd2);
		var sprite = new Sprite();
		sprite.addChild(bitmap);
		bitmap.x -= bitmap.width * 0.5;
		bitmap.y -= bitmap.height * 0.5;
		bitmap.smoothing = true;
		sprite.scaleY = 1.5;
		sprite.scaleX = 0.5;
		addChild(sprite);
	}
	
	public override function Update(Spawn:Function)
	{
		super.Update(Spawn);
	}
	
	public override function LevelCollide(level:Level)
	{
		if (x >= 480 || x <= -480 || y >= 270 || y <= -270)
		{
			active = false;
		}
	}
}