package world;

import menu.DebugPage;
import openfl.display.BlendMode;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.Function;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import world.tiles.DoorTile;

/**
 * ...
 * @author Victor Reynolds
 */
class Player extends Entity 
{
	private var sprite:Sprite;
	private var shootCooldown:Float = 0;
	private var turnSpeed = 6;
	private var shootRate = 10;
	private var shotSpeed = 45;
	private var shotStartDist = 0.65;
	private var shotSpread = 4;
	private var speed = 0.2;
	private var boostSpeed = 0.4;
	private var boostFuel:Float = 0;
	private var maxBoostFuel:Float = 25;
	
	private var thrustPics:Array<Sprite>;
	private var thrustVec:Point;
	
	public function new() 
	{
		super();
		hitbox.MakeSquare(30);
		//showHitbox = true;
		
		var bitmapData = openfl.Assets.getBitmapData("img/ship2.png");
		var bitmap = new Bitmap (bitmapData);
		sprite = new Sprite();
		sprite.addChild(bitmap);
		bitmap.x -= bitmap.width * 0.5;
		bitmap.y -= bitmap.height * 0.6;
		sprite.scaleX = sprite.scaleY = 1;
		bitmap.smoothing = true;
		
		addChild(sprite);
		
		CreateThrustEffect();
		thrustVec = new Point();
		
		rf = 0.2;//0.8;
		tf = 0.0075;//0.98;
	}
	
	public override function Update(Spawn:Function)
	{
		super.Update(Spawn);
		
		thrustVec.setTo(0, 0);
		if (Input.KeyHeld(65))
		{
			thrustVec.x -= 1;
		}
		if (Input.KeyHeld(68))
		{
			thrustVec.x += 1;
		}
		if (Input.KeyHeld(87))
		{
			thrustVec.y -= 1;
		}
		if (Input.KeyHeld(83))
		{
			thrustVec.y += 1;
		}
		
		thrustVec.normalize(1);
		xv += thrustVec.x * speed * t;
		yv += thrustVec.y * speed * t;
		
		if (boostFuel < maxBoostFuel)
		{
			boostFuel += 0.2 * t;
		}
		if (Input.KeyHeld(16))
		{
			if (boostFuel >= 1)
			{
				xv += boostSpeed * t * (Math.sin((180 - rotation) * (Math.PI / 180)));
				yv += boostSpeed * t * (Math.cos((180 - rotation) * (Math.PI / 180)));
				World.shake += 0.3;
				thrustPics[5].alpha += 0.3;
				boostFuel -= 1.0 * t;
			} else if (boostFuel > 0)
			{
				xv += 0.2 * boostSpeed * t * (Math.sin((180 - rotation) * (Math.PI / 180)));
				yv += 0.2 * boostSpeed * t * (Math.cos((180 - rotation) * (Math.PI / 180)));
				thrustPics[5].alpha += 0.05;
				boostFuel -= 0.5 * t;
			}
		}
		if (Input.MouseHeld() && shootCooldown > shootRate)
		{
			var shot:Shot = new Shot();
			shot.x = x;
			shot.y = y;
			shot.rotation = rotation + ((Math.random() - 0.5) * (Math.random() - 0.5)) * shotSpread;
			shot.xv = shotSpeed * Math.sin((180 - shot.rotation) * (Math.PI / 180));
			shot.yv = shotSpeed * Math.cos((180 - shot.rotation) * (Math.PI / 180));
			shot.x += shot.xv * shotStartDist; //shot starts a little distance away from the ship
			shot.y += shot.yv * shotStartDist;
			Spawn(shot);
			
			shootCooldown = 0;
		}
		
		UpdateThrustAnimation();
		
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
		
		av += rotationDiff * turnSpeed * t;
	}
	
	public override function HitTile(levelTile:LevelTile, level:Level)
	{
		if (Std.is(levelTile, DoorTile))
		{
			var door:DoorTile = cast(levelTile, DoorTile);
			if (door.IsVertical())
			{
				if ((x > door.x && px < door.x) || (px > door.x && x < door.x)) level.EnteredDoor(door, y - door.y);
			}
			else
			{
				if ((y > door.y && py < door.y) || (py > door.y && y < door.y)) level.EnteredDoor(door, x - door.x);
			}
		}
	}
	
	function CreateThrustEffect() 
	{
		var thrustAsset = Assets.getBitmapData("img/thrust01.png");
		thrustPics = new Array<Sprite>();
		for (i in 0...6)
		{
			var thrustSprite = new Sprite();
			var thrustBmp = new Bitmap(thrustAsset);
			if (i == 5)
			{
				thrustBmp.bitmapData = thrustBmp.bitmapData.clone();
				thrustBmp.bitmapData.colorTransform(new Rectangle(0, 0, thrustBmp.width, thrustBmp.height), new ColorTransform(1, 0, 0, 1, 255, 150, 0, 0));
			}
			thrustSprite.addChild(thrustBmp);
			thrustSprite.getChildAt(0).x -= thrustSprite.getChildAt(0).width / 2;
			addChildAt(thrustSprite, 0);
			thrustPics.push(thrustSprite);
		}
		//back
		thrustPics[0].y = 14;
		thrustPics[0].scaleY = 0.6;
		thrustPics[0].alpha = 0;
		//left
		thrustPics[1].rotation = 90;
		thrustPics[1].scaleX = 0.5;
		thrustPics[1].x = -7;
		thrustPics[1].alpha = 0;
		//retro_left
		thrustPics[2].rotation = 180;
		thrustPics[2].scaleX = 0.4;
		thrustPics[2].scaleY = 0.8;
		thrustPics[2].x = -12;
		thrustPics[2].alpha = 0;
		//retro_right
		thrustPics[3].rotation = 180;
		thrustPics[3].scaleX = 0.4;
		thrustPics[3].scaleY = 0.8;
		thrustPics[3].x = 12;
		thrustPics[3].alpha = 0;
		//right
		thrustPics[4].rotation = 270;
		thrustPics[4].scaleX = 0.5;
		thrustPics[4].x = 7;
		thrustPics[4].alpha = 0;
		//booster
		thrustPics[5].y = 14;
		thrustPics[5].scaleX = 1.2;
		thrustPics[5].alpha = 0;
	}
	
	function UpdateThrustAnimation() 
	{
		for (thrustSprite in thrustPics)
		{
			if (thrustSprite.alpha > 0.01) thrustSprite.alpha *=  0.8;
		}
		
		var thrustDir = Math.atan2(thrustVec.y, thrustVec.x);
		var localThrustDir = thrustDir - ((rotation / 180) * Math.PI);
		var intensity = 0.15;
		var randomize = (4 + Math.random()) / 4;
		
		if (thrustVec.x == 0 && thrustVec.y == 0) intensity = 0;
		
		thrustPics[0].alpha += Math.max(0, -Math.sin(localThrustDir)) * intensity;
		thrustPics[0].scaleY = 0.01 + (0.6 * thrustPics[0].alpha * randomize);
		
		thrustPics[1].alpha += Math.max(0, Math.cos(localThrustDir)) * intensity;
		thrustPics[1].scaleY = 0.01 + (thrustPics[1].alpha * randomize);
		
		thrustPics[2].alpha += Math.max(0, Math.sin(localThrustDir)) * intensity;
		thrustPics[2].scaleY = 0.01 + (0.8 * thrustPics[2].alpha * randomize);
		thrustPics[3].alpha = thrustPics[2].alpha;
		thrustPics[3].scaleY = thrustPics[2].scaleY;
		
		thrustPics[4].alpha += Math.max(0,-Math.cos(localThrustDir)) * intensity;
		thrustPics[4].scaleY = 0.01 + (thrustPics[4].alpha * randomize);
		
		thrustPics[5].scaleY = 0.01 + (1.6 * thrustPics[5].alpha * randomize);
		thrustPics[0].alpha += thrustPics[5].alpha;
		thrustPics[0].scaleY += 0.3 * thrustPics[5].alpha * randomize;
	}
}