package world;

import menu.DebugPage;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.Assets;
import openfl.geom.Rectangle;
import openfl.utils.Function;
import world.HitShape.CollisionResult;
import world.tiles.DoorTile;

/**
 * ...
 * @author Victor Reynolds
 */
class Shot extends Entity 
{
	public var isPlayerShot = true;
	
	var shotHit = false;
	var shotHitAnim = 5.0;
	var shotStart = true;
	
	var laserSprite:Sprite;
	var hitSprite:Sprite;
	
	var maxAge:Float = 60;
	
	var age:Float = 0;
	
	public function new() 
	{
		super();
		
		laserSprite = new Sprite();
		addChild(laserSprite);
		hitSprite = new Sprite();
		addChild(hitSprite);
		
		laserSprite.visible = false;
		hitSprite.visible = true;
		hitSprite.rotation = Math.random() * 360;
		
		hitbox.AddPoint(0, 0);
		elasticity = 1;
	}
	
	public override function Update(Spawn:Function)
	{
		super.Update(Spawn);
		age += t;
		laserSprite.visible = true;
		hitSprite.visible = false;
		if (shotHit)
		{
			laserSprite.visible = false;
			hitSprite.visible = true;
			hitSprite.rotation = Math.random() * 360;
			shotHitAnim -= t;
			hitSprite.scaleX = hitSprite.scaleY = shotHitAnim * 0.2;
			if (shotHitAnim < 0)
			{
				active = false;
				hitSprite.visible = false;
			}
		}
		if (age > maxAge) active = false;
	}
	
	public override function LevelCollide(level:Level)
	{
		CollideLevelTiles(level);
		CollideLevelBorders(level);
		if (shotHit && age <= 1)
		{
			var shotwidth = Math.sqrt(Math.pow(x - px, 2) + Math.pow(y - py, 2)) / 45;
			laserSprite.scaleY = shotwidth;
		}
	}
	
	public override function CollideLevelBorders(level:Level)
	{
		var room:LevelRoom = level.currentRoom;
		super.CollideLevelBorders(level);
		if (x >= room.xmax || x <= room.xmin || y >= room.ymax || y <= room.ymin)
		{
			active = false;
		}
	}
	
	public override function CollideLevelTiles(level:Level)
	{
		var room:LevelRoom = level.currentRoom;
		var tpx = px;
		var tpy = py;
		var didHit = false;
		var bounceLimit = 6;
		var numBounces = 0;
		
		do
		{
			didHit = false;
			var pushOutX:Float = 0.0;
			var pushOutY:Float = 0.0;
			var xmin = room.GetIndexAtX(Math.min(tpx, x) + hitbox.GetXmin());
			var xmax = room.GetIndexAtX(Math.max(tpx, x) + hitbox.GetXmax());
			var ymin = room.GetIndexAtY(Math.min(tpy, y) + hitbox.GetYmin());
			var ymax = room.GetIndexAtY(Math.max(tpy, y) + hitbox.GetYmax());
			
			var lastHitTile:LevelTile = room.tiles[0][0];
			var lowestMoveFraction:Float = 1.0;
			
			for (i in ymin...ymax + 1)
			{
				for (j in xmin...xmax + 1)
				{
					if (room.tiles[i][j] == null || room.tiles[i][j].hitShape == null) continue;
					else
					{
						if (room.tiles[i][j].PointInside(tpx, tpy))
						{
							shotHit = true;
							x = tpx;
							y = tpy;
							xv = 0;
							yv = 0;
							
							HitTile(room.tiles[i][j], level);
							
							return;
						}
						var collisionResult:CollisionResult = hitbox.Collide(room.tiles[i][j].x - x, room.tiles[i][j].y - y, x - tpx, y - tpy, room.tiles[i][j].hitShape);
						if (collisionResult.movefraction < lowestMoveFraction)
						{
							lowestMoveFraction = collisionResult.movefraction;
							lastHitTile = room.tiles[i][j];
							pushOutX = collisionResult.pushOutX;
							pushOutY = collisionResult.pushOutY;
						}
					}
				}
			}
			if (lowestMoveFraction < 1.0)
			{
				++numBounces;
				didHit = true;
				HitTile(lastHitTile, level);
				
				x = x - ((x - tpx) * (1 - lowestMoveFraction));
				y = y - ((y - tpy) * (1 - lowestMoveFraction));
				xv = 0;
				yv = 0;
				
				shotHit = true;
			}
			if (numBounces >= bounceLimit)
			{
				didHit = false;
			}
		} while (didHit);
	}
	
	public override function HitTile(levelTile:LevelTile, level:Level)
	{
		var room:LevelRoom = level.currentRoom;
		if (Std.is(levelTile, DoorTile) && isPlayerShot)
		{
			var door:DoorTile = cast(levelTile, DoorTile);
			var targetRoom:Int = room.doors[door.GetID()].targetRoom;
			var targetDoor:String = room.doors[door.GetID()].targetDoor;
			
			//if (room.doors[door.GetID()].isOpen == false) DebugPage.Log("Opened Door " + door.GetID() + " => " + targetRoom + ":" + targetDoor);
			room.doors[door.GetID()].SetOpen(true);
			level.rooms[targetRoom].doors[targetDoor].SetOpen(true);
		}
	}
	
	public function ShotHit(collisionResult:CollisionResult)
	{
		shotHit = true;
		x = x - ((x - px) * (1 - collisionResult.movefraction));
		y = y - ((y - py) * (1 - collisionResult.movefraction));
		xv = 0;
		yv = 0;
		laserSprite.visible = false;
		hitSprite.visible = true;
		shotHitAnim -= 1.0;
		hitSprite.scaleX = hitSprite.scaleY = shotHitAnim * 0.2;
	}
	
	public function AlreadyHit():Bool
	{
		return shotHit;
	}
}