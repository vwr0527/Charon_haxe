package world;

import openfl.display.Sprite;
import openfl.utils.Function;
import world.LevelRoom;

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
	
	public function LevelCollide(room:LevelRoom)
	{
		CollideLevelTiles(room);
		CollideLevelBorders(room);
	}
	
	public function CollideLevelBorders(room:LevelRoom) 
	{
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
	public function CollideLevelTiles(room:LevelRoom)
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
			
			for (i in ymin...ymax + 1)
			{
				for (j in xmin...xmax + 1)
				{
					if (room.tiles[i][j] == null) continue;
					else
					{
						hitbox.Collide(room.tiles[i][j].x - x, room.tiles[i][j].y - y, x - tpx, y - tpy, room.tiles[i][j].hitShape);
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