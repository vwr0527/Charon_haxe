package world;

import openfl.display.Sprite;
import openfl.utils.Function;

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
		
		var half = hbs / 2;
		var xmin = Math.min(Math.min(Math.min(px - half, px + half), x - half), x + half);
		var xmax = Math.max(Math.max(Math.max(px - half, px + half), x - half), x + half);
		var ymin = Math.min(Math.min(Math.min(py - half, py + half), y - half), y + half);
		var ymax = Math.max(Math.max(Math.max(py - half, py + half), y - half), y + half);
		
		level.TestTileAt(xmin, ymin);
		level.TestTileAt(xmin, ymax);
		level.TestTileAt(xmax, ymin);
		level.TestTileAt(xmax, ymax);
	}
}