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

/**
 * ...
 * @author ...
 */
class LevelTile extends Sprite
{
	public var hitShape:HitShape;
	private var sprite:Sprite;
	private var noclip:Bool;
	
	public function new() 
	{
		super();
		hitShape = new HitShape();
		noclip = false;
	}
	
	public function UsePic(assetName:String, rot:Float = 0, scaling:Float = 1.0)
	{
		if (sprite != null)
		{
			removeChild(sprite);
			sprite = null;
		}
		try {
			var bmd:BitmapData = Assets.getBitmapData(assetName);
			var bmd2:BitmapData = new BitmapData(bmd.width, bmd.height);
			bmd2.threshold(bmd, bmd2.rect, new Point(0, 0), "==", 0xff000000, 0x00000000, 0xffffffff, true);
			
			var bitmap = new Bitmap(bmd2);
			sprite = new Sprite();
			sprite.addChild(bitmap);
			bitmap.x -= bitmap.width * 0.5;
			bitmap.y -= bitmap.height * 0.5;
			bitmap.smoothing = true;
			sprite.scaleY = sprite.scaleX = scaling;
			sprite.rotation = rot;
			addChild(sprite);
		} catch (msg:String) {
			trace(msg);
			hitShape.graphic.visible = true;
			sprite = hitShape.graphic;
			addChild(sprite);
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
	
	public function NoCollide() 
	{
		return noclip;
	}
	
	public static var size:Float = 32;
	
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