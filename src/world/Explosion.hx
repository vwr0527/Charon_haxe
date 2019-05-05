package world;

import openfl.display.BitmapData;
import openfl.geom.ColorTransform;
import openfl.utils.Function;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;

/**
 * ...
 * @author Victor Reynolds
 */
class Explosion extends Entity 
{
	public var age:Float = 0;
	public var speed:Float = 0.15;
	public var scale:Float = 1.8;
	
	private var bang:Sprite;
	private var med:Sprite;
	private var dark:Sprite;
	
	public function new() 
	{
		super();
		
		var bitmapData:BitmapData = Assets.getBitmapData("img/explosion1.png");
		
		var bitmap = new Bitmap (bitmapData.clone());
		bitmap.bitmapData.colorTransform(bitmapData.rect, new ColorTransform(2, 2, 2, 2, 50, 50, 50, 0));
		bitmap.x -= bitmap.width * 0.5;
		bitmap.y -= bitmap.height * 0.5;
		bitmap.smoothing = true;
		bang = new Sprite();
		bang.addChild(bitmap);
		
		var bitmap2 = new Bitmap (bitmapData);
		bitmap2.x -= bitmap2.width * 0.5;
		bitmap2.y -= bitmap2.height * 0.5;
		bitmap2.smoothing = true;
		med = new Sprite();
		med.addChild(bitmap2);
		
		var bitmap3 = new Bitmap (bitmapData.clone());
		bitmap3.bitmapData.colorTransform(bitmapData.rect, new ColorTransform(0.2, 0.1, 0.2, 1, 80, 70, 80, 0));
		bitmap3.x -= bitmap3.width * 0.5;
		bitmap3.y -= bitmap3.height * 0.5;
		bitmap3.smoothing = true;
		dark = new Sprite();
		dark.addChild(bitmap3);
		
		addChild(dark);
		addChild(med);
		addChild(bang);
		
		scaleX = scaleY = scale;
	}
	
	public override function Update(Spawn:Function)
	{
		super.Update(Spawn);
		
		dark.scaleX = dark.scaleY = (1.5 + (age / 5));
		dark.alpha = (10 - age) / 15;
		if (dark.alpha < 0) dark.visible = false;
		
		med.alpha = (6 - age) / 5;
		med.scaleX = med.scaleY = 1.2 - (age * 0.05);
		if (med.alpha < 0) med.visible = false;
		
		bang.alpha = 1 - (age * 0.55);
		bang.scaleX = bang.scaleY = 2.2 - (age * 0.7);
		if (bang.alpha < 0) bang.visible = false;
		
		if (age >= 10)
		{
			active = false;
		}
		
		age += speed * t;
	}
}