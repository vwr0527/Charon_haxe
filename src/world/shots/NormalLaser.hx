package world.shots;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.Assets;
/**
 * ...
 * @author Victor Reynolds
 */
class NormalLaser extends Shot 
{
	static var loaded = false;
	static var bmd:BitmapData;
	
	public function new() 
	{
		super();
		
		if (!loaded)
		{
			bmd = openfl.Assets.getBitmapData("img/shot2.png");
			bmd = bmd.clone();
			bmd.threshold(bmd, bmd.rect, new Point(0, 0), "==", 0xff000000, 0x00000000, 0xffffffff, true);
		}
		
		var bitmap = new Bitmap(bmd);
		laserSprite.addChild(bitmap);
		bitmap.x -= bitmap.width * 0.5;
		//bitmap.y -= bitmap.height * 0.5;
		bitmap.smoothing = true;
		laserSprite.scaleY = 1.5;
		laserSprite.scaleX = 0.5;
		
		var bitmap2 = new Bitmap(openfl.Assets.getBitmapData("img/hit01.png"));
		hitSprite.addChild(bitmap2);
		bitmap2.width *= 2.0;
		bitmap2.height = bitmap2.width;
		bitmap2.x -= bitmap2.width * 0.5;
		bitmap2.y -= bitmap2.height * 0.5;
		bitmap2.smoothing = true;
	}
}