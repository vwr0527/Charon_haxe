package world;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author ...
 */
class HitShape
{
	var p:Array<Point>;
	var xmin:Float = 0;
	var xmax:Float = 0;
	var ymin:Float = 0;
	var ymax:Float = 0;
	public var graphic:Sprite;
	
	public function new() 
	{
		p = new Array();
		graphic = new Sprite();
		graphic.visible = false;
	}
	public function MakeSquare(size:Float)
	{
		var half = size / 2;
		p.push(new Point(-half, -half));
		p.push(new Point(half, -half));
		p.push(new Point(half, half));
		p.push(new Point(-half, half));
		xmin = -half;
		xmax = half;
		ymin = -half;
		ymax = half;
		
		graphic.graphics.lineStyle(1, 0x00ff00);
		graphic.graphics.drawRect( -half, -half, size, size);
	}
	public function AddPoint(x:Float, y:Float)
	{
		p.push(new Point(x, y));
		if (x < xmin) xmin = x;
		if (x > xmax) xmax = x;
		if (y < ymin) ymin = y;
		if (y > ymax) ymax = y;
		
		graphic.graphics.clear();
		graphic.graphics.lineStyle(1, 0x00ff00);
		graphic.graphics.moveTo(p[0].x, p[0].y);
		for (i in 1...p.length + 1)
		{
			if (i >= p.length)
			{
				graphic.graphics.lineTo(p[0].x, p[0].y);
			}
			else
			{
				graphic.graphics.lineTo(p[i].x, p[i].y);
			}
		}
	}
	
	public function GetX(i:Int):Float
	{
		if (i < 0 || i >= p.length) return 0;
		return p[i].x;
	}
	public function GetY(i:Int):Float
	{
		if (i < 0 || i >= p.length) return 0;
		return p[i].y;
	}
	public function GetNumPts():Int
	{
		return p.length;
	}
	
	public function GetXmax():Float
	{
		return xmax;
	}
	public function GetXmin():Float
	{
		return xmin;
	}
	public function GetYmax():Float
	{
		return ymax;
	}
	public function GetYmin():Float
	{
		return ymin;
	}
	
	private static var movefraction:Float;
	private static var pushOutX:Float;
	private static var pushOutY:Float;
	
	public function Collide(x:Float, y:Float, dx:Float, dy:Float, other:HitShape)
	{
		CollideOneWay(x, y, dx, dy, other, false);
		other.CollideOneWay( -x, -y, -dx, -dy, this, true);
	}
	
	private function CollideOneWay(x:Float, y:Float, dx:Float, dy:Float, other:HitShape, reverse:Bool)
	{
		for (i in 0...p.length)
		{
			var sx = p[i].x - dx;
			var sy = p[i].y - dy;
			var ex = p[i].x;
			var ey = p[i].y;
			for (j in 0...other.GetNumPts())
			{
				var k = j + 1;
				if (k >= other.GetNumPts()) k = 0;
				var wx1 = other.GetX(j) + x;
				var wy1 = other.GetY(j) + y;
				var wx2 = other.GetX(k) + x;
				var wy2 = other.GetY(k) + y;
				LineLineIntersectSpecial(sx, sy, ex, ey, wx1, wy1, wx2, wy2, reverse);
			}
		}
	}
	
	//from Andre LeMothe's "Tricks of the Windows Game Programming Gurus", via https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
	public function LineLineIntersectSpecial(startx:Float, starty:Float, endx:Float, endy:Float, wallx1:Float, wally1:Float, wallx2:Float, wally2:Float, reverse:Bool)
	{
		var s1_x:Float = endx - startx;
		var s1_y:Float = endy - starty;
		var s2_x:Float = wallx2 - wallx1;
		var s2_y:Float = wally2 - wally1;
		
		var s:Float = ( -s1_y * (startx - wallx1) + s1_x * (starty - wally1)) / ( -s2_x * s1_y + s1_x * s2_y);
		var t:Float = ( s2_x * (starty - wally1) - s2_y * (startx - wallx1)) / ( -s2_x * s1_y + s1_x * s2_y);
		
		if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
		{
			if (t < movefraction)
			{
				movefraction = t;
				var dist = Math.sqrt(Math.pow(wallx2 - wallx1, 2) + Math.pow(wally2 - wally1, 2));
				pushOutX = (wally2 - wally1) / dist;
				pushOutY = (wallx2 - wallx1) / dist;
				if (reverse)
				{
					pushOutX *= -1;
					pushOutY *= -1;
				}
			}
		}
	}
	
	public static function ResetMovefraction()
	{
		movefraction = 1.0;
	}
	
	public static function GetMovefraction():Float
	{
		return movefraction;
	}
	
	public static function GetPushoutX():Float
	{
		return pushOutX;
	}
	
	public static function GetPushoutY():Float
	{
		return pushOutY;
	}
	
	//copied from http://blackpawn.com/texts/pointinpoly/
	public function PointInTriangle(xpos:Float, ypos:Float):Bool
	{
		if (p.length == 3)
		{
			// Compute vectors        
			var v0:Point = new Point(p[2].x - p[0].x, p[2].y - p[0].y);
			var v1:Point = new Point(p[1].x - p[0].x, p[1].y - p[0].y);
			var v2:Point = new Point(xpos - p[0].x, ypos - p[0].y);
			
			// Compute dot products
			var dot00 = dot(v0, v0);
			var dot01 = dot(v0, v1);
			var dot02 = dot(v0, v2);
			var dot11 = dot(v1, v1);
			var dot12 = dot(v1, v2);
			
			// Compute barycentric coordinates
			var invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
			var u = (dot11 * dot02 - dot01 * dot12) * invDenom;
			var v = (dot00 * dot12 - dot01 * dot02) * invDenom;
			
			// Check if point is in triangle
			return (u >= 0) && (v >= 0) && (u + v < 1);
		}
		return false;
	}
	
	public function PointInRect(xpos:Float, ypos:Float):Bool
	{
		if (p.length == 4)
		{
			return xpos > GetXmin() && xpos < GetXmax() && ypos > GetYmin() && ypos < GetYmax();
		}
		return false;
	}
	
	function dot(p1:Point, p2:Point):Float
	{
		return (p1.x * p2.x) + (p1.y * p2.y);
	}
}