package world.shots;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;

/**
 * ...
 * @author Victor Reynolds
 */
class PlasmaBall extends Shot 
{
	static var loaded = false;
	static var bmd:BitmapData;
	static var bmd2:BitmapData;
	public function new() 
	{
		super();
		
		if (!loaded)
		{
			bmd = openfl.Assets.getBitmapData("img/pball.png");
			bmd = bmd.clone();
			bmd.colorTransform(bmd.rect, new ColorTransform(0.3, 1, 0.6, 1, 0, 255, 0, 0));
			
			bmd2 = openfl.Assets.getBitmapData("img/hit01.png");
			bmd2 = bmd2.clone();
			bmd2.colorTransform(bmd2.rect, new ColorTransform(0.8, 1, 0.9, 1, 0, 0, 0, 0));
			
			loaded = true;
		}
		
		var bitmap = new Bitmap(bmd);
		laserSprite.addChild(bitmap);
		bitmap.width *= 0.5;
		bitmap.height *= 0.5;
		bitmap.x -= bitmap.width * 0.5;
		//bitmap.y -= bitmap.height * 0.5;
		bitmap.smoothing = true;
		
		var bitmap2 = new Bitmap(bmd2);
		hitSprite.addChild(bitmap2);
		bitmap2.width *= 3;
		bitmap2.height *= 3;
		bitmap2.x -= bitmap2.width * 0.5;
		bitmap2.y -= bitmap2.height * 0.5;
		bitmap2.smoothing = true;
		
		maxAge = 200;
	}
}