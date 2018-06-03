package world;

import openfl.utils.Function;
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
	private var shootCooldown:Float = 0;
	
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
		
		rf = 0.2;//0.8;
		tf = 0.01;//0.98;
	}
	
	public override function Update(Spawn:Function)
	{
		super.Update(Spawn);
		
		var speed = 0.4 * t;
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
		if (Input.MouseHeld() && shootCooldown > 8)
		{
			var shot:Shot = new Shot();
			shot.x = x;
			shot.y = y;
			shot.xv = 50 * Math.sin((180 - rotation) * (Math.PI / 180));
			shot.yv = 50 * Math.cos((180 - rotation) * (Math.PI / 180));
			shot.x += shot.xv;
			shot.y += shot.yv;
			shot.rotation = rotation;
			Spawn(shot);
			
			shootCooldown = 0;
		}
		shootCooldown += t;
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
		
		av += rotationDiff * 4 * t;
	}
}