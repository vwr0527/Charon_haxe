package world;

import menu.DebugPage;
import openfl.geom.Point;
import openfl.utils.Function;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import world.HitShape.CollisionResult;
import world.shots.PlasmaBall;

/**
 * ...
 * @author Victor Reynolds
 */
class Enemy extends Entity 
{
	private var sprite:Sprite;
	private var shootCooldown:Float = 0;
	private var turnSpeed = 6;
	private var shootRate = 40;
	private var shotSpeed = 15;
	private var shotSpread = 4;
	private var shotSide = false;
	public var age:Float = 0;
	public var hp:Float = 10;
	
	public function new() 
	{
		super();
		hitbox.MakeSquare(50);
		//showHitbox = true;
		
		var bitmapData = openfl.Assets.getBitmapData("img/enemy01.png");
		bitmapData.threshold(bitmapData, bitmapData.rect, new Point(0, 0), "==", 0xffff00ff, 0x00000000, 0xffffffff, true);
		var bitmap = new Bitmap (bitmapData);
		sprite = new Sprite();
		sprite.addChild(bitmap);
		bitmap.x -= bitmap.width * 0.5;
		bitmap.y -= bitmap.height * 0.6;
		sprite.scaleX = sprite.scaleY = 1;
		bitmap.smoothing = true;
		
		addChild(sprite);
		
		rf = 0.2;//0.8;
		tf = 0.005;//0.98;
	}
	
	public override function Update(Spawn:Function)
	{
		super.Update(Spawn);
		age += t;
		
		var speed = t * 0.05;
		
		if (Std.int(age) % 100 < 50)
		{
			xv += speed;
		}
		else
		{
			xv -= speed;
		}
		if (Std.int(age) % 100 < 75 && Std.int(age) % 100 > 25)
		{
			yv += speed;
		}
		else
		{
			yv -= speed;
		}
		
		if (shootCooldown > shootRate)
		{
			if (Math.random() > 0.5)
			{
				var shot:Shot = new PlasmaBall();
				shot.isPlayerShot = false;
				shot.x = x;
				shot.y = y;
				shot.rotation = rotation + ((Math.random() - 0.5) * (Math.random() - 0.5)) * shotSpread;
				shot.xv = shotSpeed * Math.sin((180 - shot.rotation) * (Math.PI / 180));
				shot.yv = shotSpeed * Math.cos((180 - shot.rotation) * (Math.PI / 180));
				
				shot.x += shot.xv * 2; //shot starts a little distance away from the ship
				shot.y += shot.yv * 2;
				if (shotSide)
				{
					shot.x += shot.yv * 1.5;
					shot.y -= shot.xv * 1.5;
				}
				else
				{
					shot.x -= shot.yv * 1.5;
					shot.y += shot.xv * 1.5;
				}
				
				shotSide = !shotSide;
				
				Spawn(shot);
			}
			shootCooldown = 0;
		}
		shootCooldown += t + (Math.random());
		
		SpawnFcn = Spawn;
	}
	
	var SpawnFcn:Function;
	
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
		
		av += rotationDiff * turnSpeed * t;
	}
	
	public function CheckShotHit(shot:Shot)
	{
		var collisionResult:CollisionResult = hitbox.Collide(shot.x - x, shot.y - y, (shot.px - px) - (shot.x - x), (shot.py - py) - (shot.y - y), shot.hitbox);
		if (collisionResult.movefraction < 1)
		{
			av += (Math.random() - 0.5) * 50;
			xv += shot.xv / 30;
			yv += shot.yv / 30;
			shot.ShotHit(collisionResult);
			hp -= 2;
			if (hp <= 0)
			{
				active = false;
				var explosion = new Explosion();
				explosion.x = x;
				explosion.y = y;
				SpawnFcn(explosion);
				//DebugPage.Log("Destroyed Enemy " + name);
			}
			else
			{
				//DebugPage.Log("Hit Enemy " + name);
			}
		}
	}
}