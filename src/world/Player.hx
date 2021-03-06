package world;

import menu.DebugPage;
import menu.HudPage;
import openfl.display.BlendMode;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.Function;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import world.HitShape.CollisionResult;
import world.level.Level;
import world.level.LevelTile;
import world.shots.NormalLaser;
import world.level.tiles.DoorTile;

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
	private var shield:Float = 25;
	private var maxShield:Float = 25;
	private var shieldRechargeRate:Float = 0.1;
	private var shieldPauseTime:Float = 0;
	private var shieldRechargePause:Float = 80.0;
	private var shieldBreakPause:Float = 240.0;
	private var shieldBreakAnim:Float = 0;
	private var health:Float = 20;
	private var maxHealth:Float = 20;
	
	private var thrustPics:Array<Sprite>;
	private var thrustVec:Point;
	
	private var shieldEffects:Sprite;
	private var shieldRippleContainer:Sprite;
	private var shieldPic:Sprite;
	private var shieldHitPic:Sprite;
	private var shieldRipplePic:Sprite;
	
	public function new() 
	{
		super();
		hitbox.MakeSquare(30);
		thrustVec = new Point();
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
		
		CreateShieldEffect();
		CreateThrustEffect();
		
		rf = 0.2;//0.8;
		tf = 0.0075;//0.98;
		tf = 0.01;
		speed = 0.3;
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
		
		if (Input.KeyHeld(16))
		{
			if (boostFuel >= 1)
			{
				xv += boostSpeed * t * (Math.sin((180 - rotation) * (Math.PI / 180)));
				yv += boostSpeed * t * (Math.cos((180 - rotation) * (Math.PI / 180)));
				World.shake += 0.3;
				thrustPics[5].alpha += 0.3 * t;
				boostFuel -= 1.0 * t;
			} else if (boostFuel > 0)
			{
				xv += 0.2 * boostSpeed * t * (Math.sin((180 - rotation) * (Math.PI / 180)));
				yv += 0.2 * boostSpeed * t * (Math.cos((180 - rotation) * (Math.PI / 180)));
				thrustPics[5].alpha += 0.08 * t;
				boostFuel -= 0.5 * t;
			}
		}
		if (Input.MouseHeld() && shootCooldown > shootRate)
		{
			var shot:Shot = new NormalLaser();
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
		
		thrustVec.normalize(1);
		xv += thrustVec.x * speed * t;
		yv += thrustVec.y * speed * t;
		
		if (boostFuel < maxBoostFuel)
		{
			boostFuel += 0.2 * t;
		}
		else
		{
			boostFuel = maxBoostFuel;
		}
		
		if (shield < maxShield)
		{
			if (shieldPauseTime >= 0)
			{
				shieldPauseTime -= t;
			}
			else
			{
				shieldPauseTime = 0;
				shield += shieldRechargeRate * t;
				shieldPic.alpha += (0.03 - (0.02 * (shield / maxShield))) * t;
			}
		}
		else
		{
			shield = maxShield;
		}
		
		if (health < maxHealth)
		{
			health += 0.01 * t;
		}
		else
		{
			health = maxHealth;
		}
		
		UpdateThrustAnimation();
		UpdateShieldAnimation();
		
		shootCooldown += t;
		
		HudPage.Boost = boostFuel / maxBoostFuel;
		HudPage.Shield = shield / maxShield;
		HudPage.Health = health / maxHealth;
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
	
	public function CheckShotHit(shot:Shot)
	{
		var collisionResult:CollisionResult = hitbox.Collide(shot.x - x, shot.y - y, (shot.px - px) - (shot.x - x), (shot.py - py) - (shot.y - y), shot.hitbox);
		if (collisionResult.movefraction < 1)
		{
			av += (Math.random() - 0.5) * 20;
			xv += shot.xv / 10;
			yv += shot.yv / 10;
			shot.ShotHit(collisionResult);
			World.shake += 5;
			
			var damage:Float = 5;
			
			if (shield > 0)
			{
				shield -= damage;
				
				if (shield <= 0)
				{
					shield = 0;
					shieldPauseTime = shieldBreakPause;
					shieldBreakAnim = 10;
					shieldPic.alpha = 1.0;
					shieldPic.scaleX = shieldPic.scaleY = 1.2;
				}
				else
				{
					shieldPauseTime = shieldRechargePause;
					
					shieldPic.alpha += (damage * 0.04);
					
					shieldHitPic.alpha = 1.0;
					shieldHitPic.x = shot.x - x;
					shieldHitPic.y = shot.y - y;
					shieldHitPic.rotation = ((180 * Math.atan2(shieldHitPic.y, shieldHitPic.x)) / Math.PI) + 90;
					
					shieldRippleContainer.rotation = shieldHitPic.rotation;
					shieldRipplePic.y = -10;
					shieldRipplePic.alpha = 1.0;
				}
			}
			else if (shield == 0)
			{
				health -= damage;
				if (health < 0) health = 0;
			}
		}
	}
	
	function CreateShieldEffect() 
	{
		var blueGreenTinge:ColorTransform = new ColorTransform(0, 1, 1, 1, 0, 100, 255, 0);
		
		var shieldAsset = Assets.getBitmapData("img/shieldhit3.png").clone();
		shieldAsset.colorTransform(shieldAsset.rect, blueGreenTinge);
		var shieldHitAsset = Assets.getBitmapData("img/shieldhit4.png").clone();
		shieldHitAsset.colorTransform(shieldHitAsset.rect, blueGreenTinge);
		var shieldRippleAsset = Assets.getBitmapData("img/shieldripple.png").clone();
		shieldRippleAsset.colorTransform(shieldRippleAsset.rect, blueGreenTinge);
		
		var shieldBmp = new Bitmap(shieldAsset);
		var shieldHitBmp = new Bitmap(shieldHitAsset);
		var shieldRippleBmp = new Bitmap(shieldRippleAsset);
		
		shieldEffects = new Sprite();
		shieldRippleContainer = new Sprite();
		shieldPic = new Sprite();
		shieldHitPic = new Sprite();
		shieldRipplePic = new Sprite();
		
		shieldPic.addChild(shieldBmp);
		shieldBmp.x -= shieldBmp.width / 2;
		shieldBmp.y -= shieldBmp.height / 2;
		shieldHitPic.addChild(shieldHitBmp);
		shieldHitBmp.x -= shieldHitBmp.width / 2;
		shieldHitBmp.y -= shieldHitBmp.height;
		shieldRipplePic.addChild(shieldRippleBmp);
		shieldRippleBmp.x -= shieldRippleBmp.width / 2;
		shieldRippleBmp.y -= shieldRippleBmp.height / 2;
		
		shieldPic.scaleX = shieldPic.scaleY = 1.1;
		shieldPic.alpha = 0;
		shieldHitPic.alpha = 0;
		shieldHitPic.scaleX = 1.5;
		shieldHitPic.scaleY = 1.5;
		shieldRipplePic.alpha = 0;
		shieldRipplePic.scaleX = 1.2;
		shieldRippleContainer.scaleX = shieldRippleContainer.scaleY = 2.0;
		
		shieldEffects.addChild(shieldPic);
		shieldEffects.addChild(shieldHitPic);
		shieldRippleContainer.addChild(shieldRipplePic);
		shieldEffects.addChild(shieldRippleContainer);
		addChild(shieldEffects);
		shieldEffects.y = -5;
	}
	
	function UpdateShieldAnimation()
	{
		shieldEffects.rotation = -rotation;
		shieldPic.rotation = Math.random() * 360;
		shieldPic.alpha *= 1 / Math.pow(10, 0.025 * t);
		shieldHitPic.alpha *= 1 / Math.pow(10, 0.1 * t);
		shieldRipplePic.alpha *= 1 / Math.pow(10, 0.05 * t);
		if (shieldRipplePic.y < 10)
		{
			shieldRipplePic.y += 1 * t;
		}
		
		if (shield <= 0)
		{
			if (shieldBreakAnim > 0)
			{
				shieldBreakAnim -= t;
				if (shieldBreakAnim < 0) shieldBreakAnim = 0;
				shieldPic.scaleX = shieldPic.scaleY = 1.1 + (0.4 - (shieldBreakAnim * 0.02));
				shieldPic.alpha = shieldBreakAnim * 0.15;
			}
			else
			{
				shieldPic.scaleX = shieldPic.scaleY = 1.1;
				shieldPic.alpha = 0;
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
				thrustBmp.bitmapData.colorTransform(thrustBmp.bitmapData.rect, new ColorTransform(1, 0, 0, 1, 255, 150, 0, 0));
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
			if (thrustSprite.alpha > 0.01) thrustSprite.alpha *= 1 / Math.pow(10, 0.1 * t);
		}
		
		var thrustDir = Math.atan2(thrustVec.y, thrustVec.x);
		var localThrustDir = thrustDir - ((rotation / 180) * Math.PI);
		var intensity = 0.18;
		var randomize = (4 + Math.random()) / 4;
		
		if (thrustVec.x == 0 && thrustVec.y == 0) intensity = 0;
		
		thrustPics[0].alpha += Math.max(0, -Math.sin(localThrustDir)) * intensity * t;
		thrustPics[0].scaleY = 0.01 + (0.6 * thrustPics[0].alpha * randomize);
		
		thrustPics[1].alpha += Math.max(0, Math.cos(localThrustDir)) * intensity * t;
		thrustPics[1].scaleY = 0.01 + (thrustPics[1].alpha * randomize);
		
		thrustPics[2].alpha += Math.max(0, Math.sin(localThrustDir)) * intensity * t;
		thrustPics[2].scaleY = 0.01 + (0.8 * thrustPics[2].alpha * randomize);
		thrustPics[3].alpha = thrustPics[2].alpha;
		thrustPics[3].scaleY = thrustPics[2].scaleY;
		
		thrustPics[4].alpha += Math.max(0,-Math.cos(localThrustDir)) * intensity * t;
		thrustPics[4].scaleY = 0.01 + (thrustPics[4].alpha * randomize);
		
		thrustPics[5].scaleY = 0.01 + (1.6 * thrustPics[5].alpha * randomize);
		thrustPics[0].alpha += 0.7 * thrustPics[5].alpha * t;
		thrustPics[0].scaleY += 0.3 * thrustPics[5].alpha * randomize * t;
	}
}