package world;

import openfl.geom.Point;
import openfl.utils.Function;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import world.HitShape.CollisionResult;

/**
 * ...
 * @author Victor Reynolds
 */
class Explosion extends Entity 
{
	private var sprite:Sprite;
	public var age:Int = 0;
	
	public function new() 
	{
		super();
		
		var bitmapData = openfl.Assets.getBitmapData("img/explosion1.png");
		var bitmap = new Bitmap (bitmapData);
		sprite = new Sprite();
		sprite.addChild(bitmap);
		bitmap.x -= bitmap.width * 0.5;
		bitmap.y -= bitmap.height * 0.5;
		sprite.scaleX = sprite.scaleY = 0.7;
		bitmap.smoothing = true;
		
		addChild(sprite);
	}
	
	public override function Update(Spawn:Function)
	{
		super.Update(Spawn);
		++age;
		
		sprite.scaleX = sprite.scaleY = 1 + (age / 10);
		alpha = (10 - age) / 10;
		
		if (age >= 10)
		{
			active = false;
		}
	}
}