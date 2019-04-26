package world;
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
	private var tileSize:Float;
	private var hasImg:Bool = false;
	private var sprite:Sprite;
	private var state:Int;
	private var noclip:Bool;
	
	public function new(size:Float) 
	{
		super();
		hitShape = new HitShape();
		tileSize = size;
		noclip = false;
	}
	
	public function UsePic(assetName:String)
	{
		var bmd:BitmapData = openfl.Assets.getBitmapData(assetName);
		var bmd2:BitmapData = new BitmapData(bmd.width, bmd.height);
		bmd2.threshold(bmd, bmd2.rect, new Point(0, 0), "==", 0xff000000, 0x00000000, 0xffffffff, true);
		
		var bitmap = new Bitmap(bmd2);
		sprite = new Sprite();
		sprite.addChild(bitmap);
		bitmap.x -= bitmap.width * 0.5;
		bitmap.y -= bitmap.height * 0.5;
		bitmap.smoothing = true;
		sprite.scaleY = sprite.scaleX = 1.0;
		addChild(sprite);
	}
	
	public function Update()
	{
		
	}
	
	public function SetState(st:Int)
	{
		state = st;
	}
	
	public function GetState():Int
	{
		return state;
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
	
	public static function CreateTile(tileData:String):LevelTile
	{
		var tiletype = tileData.split(",")[0];
		var tilepic = tileData.split(",")[1];
		if (tiletype == "W")
		{
			return new WallTile(32);
		}
		else if (tiletype == "BL")
		{
			return new BLWallTile(32);
		}
		else if (tiletype == "BR")
		{
			return new BRWallTile(32);
		}
		else if (tiletype == "TL")
		{
			return new TLWallTile(32);
		}
		else if (tiletype == "TR")
		{
			return new TRWallTile(32);
		}
		else return null;
	}
}