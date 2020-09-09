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
	public var points:Vector<Float>;
	
	public static var size:Float = 32;
	
	public function new() 
	{
		super();
		hitShape = new HitShape();
		noclip = false;
		points = new Vector<Float>([10, 10, 100, 10, 10, 100]);
	}
	
	public function UsePic(assetName:String, rot:Float = 0, scaling:Float = 1.0)
	{
		removeChildren();
		
		if (pic != null)
		{
			pic = null;
		}
		
		hitShape.graphic.visible = true;
		hitShape.graphic.graphics.beginFill(0xFF8000); 
		hitShape.graphic.graphics.drawTriangles(points, new Vector<Int>([0,1,2]));
		addChild(hitShape.graphic);
		return;
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
		if (hitShape == null) return false;
		xpos -= x;
		ypos -= y;
		if (hitShape.GetNumPts() == 4)
		{
			if (hitShape.PointInRect(xpos, ypos)) return true;
		}
		if (hitShape.GetNumPts() == 3)
		{
			if (hitShape.PointInTriangle(xpos, ypos)) return true;
		}
		return false;
	}
	
	public static function CreateTile(tileData:String):LevelTile
	{
		if (tileData == null) return null;
		var tileDataSplit = tileData.split(",");
		var tileType:String = tileDataSplit[0];
		var defaultTilePicRotation:Float = 0;
		
		var result:LevelTile = null;
		
		if (tileType == "W")
		{
			result = new WallTile();
		}
		else if (tileType == "BL")
		{
			result = new BLWallTile();
			defaultTilePicRotation = 270;
		}
		else if (tileType == "BR")
		{
			result = new BRWallTile();
			defaultTilePicRotation = 180;
		}
		else if (tileType == "TL")
		{
			result = new TLWallTile();
		}
		else if (tileType == "TR")
		{
			result = new TRWallTile();
			defaultTilePicRotation = 90;
		}
		else
		{
			return null;
		}
		
		if (tileDataSplit.length > 3)
		{
			result.UsePic(tileDataSplit[1], Std.parseFloat(tileDataSplit[2]), Std.parseFloat(tileDataSplit[3]));
		}
		else if (tileDataSplit.length > 2)
		{
			result.UsePic(tileDataSplit[1], Std.parseFloat(tileDataSplit[2]));
		}
		else if (tileDataSplit.length > 1)
		{
			result.UsePic(tileDataSplit[1], defaultTilePicRotation);
		}
		
		return result;
	}
}