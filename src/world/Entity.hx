package world;

import openfl.display.Sprite;
import openfl.utils.Function;
import openfl.geom.Point;
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
	private  var pushOutX:Float = 0;
	private  var pushOutY:Float = 0;
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
		var didHit:Bool = false;
		
		var tpx = px;
		var tpy = py;
		
		do
		{
			var movefraction:Float = 1.0;
			didHit = false;
			var xmin = level.GetIndexAtX(Math.min(Math.min(Math.min(tpx - half, tpx + half), x - half), x + half));
			var xmax = level.GetIndexAtX(Math.max(Math.max(Math.max(tpx - half, tpx + half), x - half), x + half));
			var ymin = level.GetIndexAtY(Math.min(Math.min(Math.min(tpy - half, tpy + half), y - half), y + half));
			var ymax = level.GetIndexAtY(Math.max(Math.max(Math.max(tpy - half, tpy + half), y - half), y + half));
			
			for (i in ymin...ymax + 1)
			{
				for (j in xmin...xmax + 1)
				{
					if (level.tiles[i][j].IsVoidTile()) continue;
					else
					{
						movefraction = Math.min(CollideEntityTile(level.tiles[i][j], level.tsize, tpx, tpy), movefraction);
					}
				}
			}
			if (movefraction < 1.0)
			{
				didHit = true;
				movefraction -= 0.01;
				x -= (x - tpx) * (1.0 - movefraction);
				y -= (y - tpy) * (1.0 - movefraction);
				x += pushOutX;
				y += pushOutY;
				xv = 0;
				yv = 0;
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
		
		var movefraction:Float = CollideLineTile(levelTile, tileSize, sx, sy, ex, ey);
		
		sx = prevx + half;
		ex = x + half;
		movefraction = Math.min(CollideLineTile(levelTile, tileSize, sx, sy, ex, ey), movefraction);
		
		sy = prevy + half;
		ey = y + half;
		movefraction = Math.min(CollideLineTile(levelTile, tileSize, sx, sy, ex, ey), movefraction);
		
		sx = prevx - half;
		ex = x - half;
		movefraction = Math.min(CollideLineTile(levelTile, tileSize, sx, sy, ex, ey), movefraction);
		
		return movefraction;
	}
	
	public function CollideLineTile(levelTile:LevelTile, tileSize:Float, sx:Float, sy:Float, ex:Float, ey:Float):Float
	{
		var thalf = tileSize / 2;
		var tsx = levelTile.x - thalf;
		var tsy = levelTile.y - thalf;
		var tex = levelTile.x + thalf;
		var tey = levelTile.y - thalf;
		
		var movefraction:Float = LineLineIntersectSpecial(sx, sy, ex, ey, tsx, tsy, tex, tey);
		
		tsx = levelTile.x + thalf;
		tey = levelTile.y + thalf;
		movefraction = Math.min(LineLineIntersectSpecial(sx, sy, ex, ey, tsx, tsy, tex, tey), movefraction);
		
		tsy = levelTile.y + thalf;
		tex = levelTile.x - thalf;
		movefraction = Math.min(LineLineIntersectSpecial(sx, sy, ex, ey, tsx, tsy, tex, tey), movefraction);
		
		tsx = levelTile.x - thalf;
		tey = levelTile.y - thalf;
		movefraction = Math.min(LineLineIntersectSpecial(sx, sy, ex, ey, tsx, tsy, tex, tey), movefraction);
		
		return movefraction;
	}
	
	public function LineLineIntersectSpecial(startx:Float, starty:Float, endx:Float, endy:Float, wallx1:Float, wally1:Float, wallx2:Float, wally2:Float):Float
	{
		// like line line intersection, but instead of a coordinate, it gives you the time of the intersection (where start=time 0.0 and end=time 1.0).
		// it assumes the first pair is a motion (start->stop) and the second pair is a wall
		var s1_x:Float = endx - startx;
		var s1_y:Float = endy - starty;
		var s2_x:Float = wallx2 - wallx1;
		var s2_y:Float = wally2 - wally1;
		
		var s:Float = ( -s1_y * (startx - wallx1) + s1_x * (starty - wally1)) / ( -s2_x * s1_y + s1_x * s2_y);
		var t:Float = ( s2_x * (starty - wally1) - s2_y * (startx - wallx1)) / ( -s2_x * s1_y + s1_x * s2_y);
		
		if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
		{
			return t;
		}
		
		return 1.0;
	}
}