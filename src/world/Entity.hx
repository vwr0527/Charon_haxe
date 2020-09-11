package world;

import openfl.display.Sprite;
import openfl.utils.Function;
import world.HitShape.CollisionResult;
import world.level.LevelRoom;
import world.level.LevelTile;
import world.level.LevelTriangle;
import world.level.Level;

/**
 * ...
 * @author Victor Reynolds
 */
class Entity extends Sprite
{
	public var active:Bool = true;
	public var xv:Float = 0;
	public var yv:Float = 0;
	public var px:Float = 0;
	public var py:Float = 0;
	public var av:Float = 0;
	public var tf:Float = 0;
	public var rf:Float = 0;
	public var hitbox:HitShape;
	public var showHitbox:Bool = false;
	public var elasticity:Float = 0.25;
	private var t:Float = 0;
	
	public function new() 
	{
		super();
		hitbox = new HitShape();
		addChild(hitbox.graphic);
	}
	
	public function Update(Spawn:Function)
	{
		//time elapsed per frame = 60 / FPS
		//1 = 1/60th of a second, 2 = 2/60ths of a second, etc
		//maximum 2, minimum 0.25
		t = Math.max(Math.min(60 / Main.getFPS(), 2), 0.25);
		
		px = x;
		py = y;
		x += xv * t;
		y += yv * t;
		rotation += av * t;
		
		xv *= 1 / Math.pow(10, tf * t);
		yv *= 1 / Math.pow(10, tf * t);
		av *= 1 / Math.pow(10, rf * t);
		
		if (showHitbox)
		{
			hitbox.graphic.rotation = -rotation;
			hitbox.graphic.visible = true;
		}
		else
		{
			hitbox.graphic.visible = false;
		}
	}
	
	public function LevelCollide(level:Level)
	{
		CollideLevelTiles(level);
		CollideLevelBorders(level);
		CollideLevelTriangles(level);
	}
	
	public function CollideLevelTriangles(level:Level) 
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
			
			var lastHitTri:LevelTriangle = null;
			var lowestMoveFraction:Float = 1.0;
			
			var allTriangles:Array<LevelTriangle> = new Array<LevelTriangle>();
			
			for (i in ymin...ymax + 1)
			{
				for (j in xmin...xmax + 1)
				{
					if (room.tiles[i][j] != null && room.tiles[i][j].levelTris.length > 0)
					{
						for (k in 0...room.tiles[i][j].levelTris.length)
						{
							allTriangles.push(room.tiles[i][j].levelTris[k]);
						}
					}
				}
			}
			for (i in 0...allTriangles.length)
			{
				if (!allTriangles[i].noclip)
				{
					var collisionResult:CollisionResult = hitbox.Collide(allTriangles[i].x - x, allTriangles[i].y - y, x - tpx, y - tpy, allTriangles[i].hitShape);
					if (collisionResult.movefraction < lowestMoveFraction)
					{
						lowestMoveFraction = collisionResult.movefraction;
						lastHitTri = allTriangles[i];
						pushOutX = collisionResult.pushOutX;
						pushOutY = collisionResult.pushOutY;
					}
				}
			}
			if (lowestMoveFraction < 1.0)
			{
				++numBounces;
				didHit = true;
				
				var ox = x;
				var oy = y;
				var wx = (x - ((x - tpx) * (1.001 - lowestMoveFraction))) + (pushOutX / 1000);
				var wy = (y - ((y - tpy) * (1.001 - lowestMoveFraction))) - (pushOutY / 1000);
				
				var factor = -(1 + elasticity) * dotprod(pushOutX, -pushOutY, ox - wx, oy - wy);
				x = ox + (factor * pushOutX) + (pushOutX / 1000);
				y = oy + (factor * -pushOutY) - (pushOutY / 1000);
				
				tpx = wx;
				tpy = wy;
				
				factor = -(1 + elasticity) * dotprod(pushOutX, -pushOutY, xv, yv);
				xv += factor * pushOutX;
				yv += factor * -pushOutY;
			}
			if (numBounces >= bounceLimit)
			{
				didHit = false;
			}
		} while (didHit);
	}
	
	public function CollideLevelBorders(level:Level)
	{
		var room:LevelRoom = level.currentRoom;
		if (x < room.xmin)
		{
			xv = 0;
			x = room.xmin;
		}
		if (x > room.xmax)
		{
			xv = 0;
			x = room.xmax;
		}
		if (y < room.ymin)
		{
			yv = 0;
			y = room.ymin;
		}
		if (y > room.ymax)
		{
			yv = 0;
			y = room.ymax;
		}
	}
	public function CollideLevelTiles(level:Level)
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
						if (hitbox.RectOverlap(px, py, room.tiles[i][j].x, room.tiles[i][j].y, room.tiles[i][j].hitShape))
						{
							HitTile(room.tiles[i][j], level);
						}
						else if (!room.tiles[i][j].noclip)
						{
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
			}
			if (lowestMoveFraction < 1.0)
			{
				++numBounces;
				didHit = true;
				HitTile(lastHitTile, level);
				
				var ox = x;
				var oy = y;
				var wx = (x - ((x - tpx) * (1.001 - lowestMoveFraction))) + (pushOutX / 1000);
				var wy = (y - ((y - tpy) * (1.001 - lowestMoveFraction))) - (pushOutY / 1000);
				
				var factor = -(1 + elasticity) * dotprod(pushOutX, -pushOutY, ox - wx, oy - wy);
				x = ox + (factor * pushOutX) + (pushOutX / 1000);
				y = oy + (factor * -pushOutY) - (pushOutY / 1000);
				
				tpx = wx;
				tpy = wy;
				
				factor = -(1 + elasticity) * dotprod(pushOutX, -pushOutY, xv, yv);
				xv += factor * pushOutX;
				yv += factor * -pushOutY;
			}
			if (numBounces >= bounceLimit)
			{
				didHit = false;
			}
		} while (didHit);
	}
	
	public function HitTile(levelTile:LevelTile, level:Level)
	{
		
	}
	
	function dotprod(x1:Float, y1:Float, x2:Float, y2:Float):Float
	{
		return (x1 * x2) + (y1 * y2);
	}
}