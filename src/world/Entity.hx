package world;

import openfl.display.Sprite;
import openfl.utils.Function;
import world.Level;

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
	public var hbs:Float = 0;
	private var t:Float = 0;
	
	public function new() 
	{
		super();
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
	}
	
	public function LevelCollide(level:Level)
	{
		CollideLevelBorders(level);
		CollideLevelTiles(level);
	}
	
	public function CollideLevelBorders(level:Level) 
	{
		if (x < level.xmin)
		{
			xv = 0;
			x = level.xmin;
		}
		if (x > level.xmax)
		{
			xv = 0;
			x = level.xmax;
		}
		if (y < level.ymin)
		{
			yv = 0;
			y = level.ymin;
		}
		if (y > level.ymax)
		{
			yv = 0;
			y = level.ymax;
		}
	}
	
	public function CollideLevelTiles(level:Level) 
	{
		var half = hbs / 2;
		var xmin:Int;
		var xmax:Int;
		var ymin:Int;
		var ymax:Int;
		var didHit:Bool = false;
		
		var tpx = px;
		var tpy = py;
		
		do
		{
			xmin = level.GetIndexAtX(Math.min(Math.min(Math.min(tpx - half, tpx + half), x - half), x + half));
			xmax = level.GetIndexAtX(Math.max(Math.max(Math.max(tpx - half, tpx + half), x - half), x + half));
			ymin = level.GetIndexAtY(Math.min(Math.min(Math.min(tpy - half, tpy + half), y - half), y + half));
			ymax = level.GetIndexAtY(Math.max(Math.max(Math.max(tpy - half, tpy + half), y - half), y + half));
			
			for (i in ymin...ymax + 1)
			{
				for (j in xmin...xmax + 1)
				{
					if (level.tiles[i][j].IsVoidTile()) continue;
					else
					{
						var movefraction = CollideEntityTile(level.tiles[i][j], level.tsize, tpx, tpy);
					}
				}
			}
		} while (didHit);
	}
	
	public function CollideEntityTile(levelTile:LevelTile, tileSize:Float, prevx:Float, prevy:Float):Float
	{
		var half = hbs / 2;
		var sx = prevx - half;
		var sy = prevy - half;
		var ex = x - half;
		var ey = y - half;
		
		var thalf = tileSize / 2;
		var tsx = levelTile.x - thalf;
		var tsy = levelTile.y - thalf;
		var tex = levelTile.x + thalf;
		var tey = levelTile.y - thalf;
		
		return 1.0;
	}
	
	public function LineLineIntersectSpecial(startx:Float, starty:Float, endx:Float, endy:Float, wallx1:Float, wally1:Float, wallx2:Float, wally2:Float):Float
	{
		// like line line intersection, but instead of a coordinate, it gives you the time of the intersection (where start=time 0.0 and end=time 1.0).
		// it assumes the first pair is a motion (start->stop) and the second pair is a wall

		return 1.0;
	}
}