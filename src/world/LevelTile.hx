package world;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import world.tiles.BLWallTile;
import world.tiles.BRWallTile;
import world.tiles.TLWallTile;
import world.tiles.TRWallTile;
import world.tiles.WallTile;
import openfl.Vector;

/**
 * ...
 * @author ...
 */
class LevelTile extends Sprite
{
	public var hitShape:HitShape;
	public var pic:Bitmap;
	public var noclip:Bool;
	
	public static var size:Float = 32;
	
	public function new() 
	{
		super();
		hitShape = new HitShape();
		noclip = false;
	}
	
	public function UsePic(assetName:String, rot:Float = 0, scaling:Float = 1.0)
	{
		removeChildren();
		
		if (pic != null)
		{
			pic = null;
		}
		
		try {
			var bmd:BitmapData = Assets.getBitmapData(assetName);
			var bmd2:BitmapData = bmd.clone();
			bmd2.threshold(bmd, bmd2.rect, new Point(0, 0), "==", 0xff000000, 0x00000000, 0xffffffff, true);
			
			pic = new Bitmap(bmd2);
			pic.x -= pic.width * 0.5;
			pic.y -= pic.height * 0.5;
			pic.smoothing = true;
			scaleY = scaleX = scaling;
			rotation = rot;
			addChild(pic);
			
			//hitShape.graphic.visible = true;
			//hitShape.graphic.graphics.beginFill(0xFF8000); 
			//hitShape.graphic.graphics.drawTriangles( new Vector<Float>([ 10,10,  100,10,  10,100, 110,10, 110,100, 20,100]));
			//addChild(hitShape.graphic);
			
		} catch (msg:String) {
			trace(msg);
			hitShape.graphic.visible = true;
			addChild(hitShape.graphic);
			return;
		}
		
		
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