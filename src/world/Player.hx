package world;

import openfl.display.Sprite;
import openfl.display.Bitmap;

/**
 * ...
 * @author Victor Reynolds
 */
class Player extends Entity 
{
	private var sprite:Sprite;

	public function new() 
	{
		super();
		
		var bitmapData = openfl.Assets.getBitmapData("img/ship_13.png");
		var bitmap = new Bitmap (bitmapData);
		sprite = new Sprite();
		sprite.addChild(bitmap);
		bitmap.x -= bitmap.width / 2;
		bitmap.y -= bitmap.height / 2;
		addChild(sprite);
	}
	
	public override function Update()
	{
		super.Update();
		
		sprite.rotation ++;
		sprite.scaleX = sprite.scaleY = 2;
	}
}