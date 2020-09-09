package world.level;
import lime.math.Vector2;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import world.level.tiles.BLWallTile;
import world.level.tiles.BRWallTile;
import world.level.tiles.TLWallTile;
import world.level.tiles.TRWallTile;
import world.level.tiles.WallTile;
import openfl.Vector;

/**
 * ...
 * @author ...
 */
class LevelTriangle extends Sprite
{
	public var hitShape:HitShape;
	public var pic:Bitmap;
	public var noclip:Bool;
	
	public static var size:Float = 32;
	
	public function new(x1:Float,y1:Float, x2:Float, y2:Float, x3:Float, y3:Float) 
	{
		super();
		hitShape = new HitShape();
		noclip = false;
		hitShape.AddPoint(x1, y1);
		hitShape.AddPoint(x2, y2);
		hitShape.AddPoint(x3, y3);
		
		
		hitShape.graphic.visible = true;
		addChild(hitShape.graphic);
	}
	
	public function Update()
	{
		
	}
	
	public function Blink()
	{
		alpha = Math.random();
	}
	
	public function PointInside(xpos:Float, ypos:Float):Bool
	{
		return hitShape.PointInTriangle(xpos, ypos);
	}
}