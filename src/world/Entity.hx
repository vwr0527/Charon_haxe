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
		var tpx = px;
		var tpy = py;
		var didHit = false;
		var bounceLimit = 6;
		var numBounces = 0;
		
		do
		{
			didHit = false;
			HitShape.ResetMovefraction();
			var xmin = level.GetIndexAtX(Math.min(tpx, x) + hitbox.GetXmin());
			var xmax = level.GetIndexAtX(Math.max(tpx, x) + hitbox.GetXmax());
			var ymin = level.GetIndexAtY(Math.min(tpy, y) + hitbox.GetYmin());
			var ymax = level.GetIndexAtY(Math.max(tpy, y) + hitbox.GetYmax());
			
			for (i in ymin...ymax + 1)
			{
				for (j in xmin...xmax + 1)
				{
					if (level.tiles[i][j].IsVoidTile()) continue;
					else
					{
						hitbox.Collide(level.tiles[i][j].x - x, level.tiles[i][j].y - y, x - tpx, y - tpy, level.tiles[i][j].hitShape);
					}
				}
			}
			if (HitShape.GetMovefraction() < 1.0)
			{
				++numBounces;
				didHit = true;
				var ox = x;
				var oy = y;
				var wx = (x - ((x - tpx) * (1.001 - HitShape.GetMovefraction()))) + (HitShape.GetPushoutX() / 1000);
				var wy = (y - ((y - tpy) * (1.001 - HitShape.GetMovefraction()))) - (HitShape.GetPushoutY() / 1000);
				
				var factor = -(1 + elasticity) * dotprod(HitShape.GetPushoutX(), -HitShape.GetPushoutY(), ox - wx, oy - wy);
				x = ox + (factor * HitShape.GetPushoutX()) + (HitShape.GetPushoutX() / 1000);
				y = oy + (factor * -HitShape.GetPushoutY()) - (HitShape.GetPushoutY() / 1000);
				
				tpx = wx;
				tpy = wy;
				
				factor = -(1 + elasticity) * dotprod(HitShape.GetPushoutX(), -HitShape.GetPushoutY(), xv, yv);
				xv += factor * HitShape.GetPushoutX();
				yv += factor * -HitShape.GetPushoutY();
			}
			if (numBounces >= bounceLimit)
			{
				didHit = false;
			}
		} while (didHit);
	}
	
	function dotprod(x1:Float, y1:Float, x2:Float, y2:Float):Float
	{
		return (x1 * x2) + (y1 * y2);
	}
}