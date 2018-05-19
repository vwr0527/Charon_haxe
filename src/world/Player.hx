package world;

import openfl.Assets;
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
		
		var bitmapData = openfl.Assets.getBitmapData("img/ship.png");
		var bitmap = new Bitmap (bitmapData);
		sprite = new Sprite();
		sprite.addChild(bitmap);
		bitmap.x -= bitmap.width * 0.5;
		bitmap.y -= bitmap.height * 0.6;
		sprite.scaleX = sprite.scaleY = 1;
		bitmap.smoothing = true;
		
		addChild(sprite);
		
		rfric = 0.8;
		fric = 0.98;
	}
	
	public override function Update()
	{
		super.Update();
		
		var speed = 0.4;
		if (Input.KeyHeld(65))
		{
			xv -= speed;
		}
		if (Input.KeyHeld(68))
		{
			xv += speed;
		}
		if (Input.KeyHeld(87))
		{
			yv -= speed;
		}
		if (Input.KeyHeld(83))
		{
			yv += speed;
		}
	}
	
	public function LookAt(xpos:Float, ypos:Float)
	{
		var targetRotation = ((180 * Math.atan2(ypos - y, xpos - x)) / Math.PI) + 90;
		
		var rotationDiff = targetRotation - rotation;
		
		while (rotationDiff > 180) rotationDiff -= 360;
		while (rotationDiff < -180) rotationDiff += 360;
		while (rotation > 180) rotation -= 360;
		while (rotation < -180) rotation += 360;
		
		var maxDiff = 90;
		if (rotationDiff > maxDiff) rotationDiff = maxDiff;
		if (rotationDiff < -maxDiff) rotationDiff = -maxDiff;
		rotationDiff /= maxDiff;
		
		av += rotationDiff * 2;
	}
}