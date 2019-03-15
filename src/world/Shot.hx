package world;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.Assets;
import openfl.utils.Function;
import world.tiles.DoorTile;

/**
 * ...
 * @author Victor Reynolds
 */
class Shot extends Entity 
{
	var shotHit = false;
	var shotHitAnim = 5.0;
	var shotStart = true;
	
	var laserSprite:Sprite;
	var hitSprite:Sprite;
	
	var age = 0;
	
	public function new() 
	{
		super();
		
		var bmd:BitmapData = openfl.Assets.getBitmapData("img/shot2.png");
		var bmd2:BitmapData = new BitmapData(bmd.width, bmd.height);
		bmd2.threshold(bmd, bmd2.rect, new Point(0, 0), "==", 0xff000000, 0x00000000, 0xffffffff, true);
		
		var bitmap = new Bitmap(bmd2);
		laserSprite = new Sprite();
		laserSprite.addChild(bitmap);
		bitmap.x -= bitmap.width * 0.5;
		//bitmap.y -= bitmap.height * 0.5;
		bitmap.smoothing = true;
		laserSprite.scaleY = 1.5;
		laserSprite.scaleX = 0.5;
		addChild(laserSprite);
		
		var bmd3:BitmapData = openfl.Assets.getBitmapData("img/hit01.png");
		
		var bitmap2 = new Bitmap(bmd3);
		hitSprite = new Sprite();
		hitSprite.addChild(bitmap2);
		bitmap2.x -= bitmap2.width * 0.5;
		bitmap2.y -= bitmap2.height * 0.5;
		bitmap2.smoothing = true;
		addChild(hitSprite);
		
		laserSprite.visible = false;
		hitSprite.visible = true;
		
		hitbox.AddPoint(0, 0);
		elasticity = 1;
	}
	
	public override function Update(Spawn:Function)
	{
		super.Update(Spawn);
		age += 1;
		laserSprite.visible = true;
		hitSprite.visible = false;
		if (shotHit)
		{
			laserSprite.visible = false;
			hitSprite.visible = true;
			shotHitAnim -= 1.0;
			hitSprite.scaleX = hitSprite.scaleY = shotHitAnim * 0.2;
			if (shotHitAnim < 0)
			{
				active = false;
				hitSprite.visible = false;
			}
		}
		if (age > 60) active = false;
	}
	
	public override function LevelCollide(room:LevelRoom)
	{
		CollideLevelTiles(room);
		CollideLevelBorders(room);
		if (shotHit && age <= 1)
		{
			var shotwidth = Math.sqrt(Math.pow(x - px, 2) + Math.pow(y - py, 2)) / 45;
			laserSprite.scaleY = shotwidth;
		}
	}
	
	public override function CollideLevelBorders(room:LevelRoom) 
	{
		super.CollideLevelBorders(room);
		if (x >= room.xmax || x <= room.xmin || y >= room.ymax || y <= room.ymin)
		{
			active = false;
		}
	}
	
	public override function CollideLevelTiles(room:LevelRoom)
	{
		var tpx = px;
		var tpy = py;
		var didHit = false;
		var bounceLimit = 6;
		var numBounces = 0;
		
		do
		{
			didHit = false;
			HitShape.ResetMovefraction();
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
					if (room.tiles[i][j] == null) continue;
					else
					{
						if (room.tiles[i][j].PointInside(tpx, tpy))
						{
							shotHit = true;
							x = tpx;
							y = tpy;
							xv = 0;
							yv = 0;
							
							HitTile(room.tiles[i][j], room);
							
							return;
						}
						hitbox.Collide(room.tiles[i][j].x - x, room.tiles[i][j].y - y, x - tpx, y - tpy, room.tiles[i][j].hitShape);
						
						if (HitShape.GetMovefraction() < lowestMoveFraction)
						{
							lowestMoveFraction = HitShape.GetMovefraction();
							lastHitTile = room.tiles[i][j];
						}
					}
				}
			}
			if (HitShape.GetMovefraction() < 1.0)
			{
				++numBounces;
				didHit = true;
				HitTile(lastHitTile, room);
				
				x = x - ((x - tpx) * (1 - HitShape.GetMovefraction()));
				y = y - ((y - tpy) * (1 - HitShape.GetMovefraction()));
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
	
	public override function HitTile(levelTile:LevelTile, room:LevelRoom) 
	{
		if (Std.is(levelTile, DoorTile))
		{
			var door:DoorTile = cast(levelTile, DoorTile);
			//door.SetOpen(true);
			room.doors[door.GetID()].SetOpen(true);
		}
	}
}