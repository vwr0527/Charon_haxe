package world;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author ...
 */
class LevelTile extends Sprite
{
	private var voidTile = true;
	public var hitShape:HitShape;
	private var tileSize:Float;
	private var hasImg:Bool = false;
	private var sprite:Sprite;
	
	public function new(size:Float) 
	{
		super();
		hitShape = new HitShape();
		tileSize = size;
	}
	
	private function UsePic(assetName:String)
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
	
	public function Init()
	{
		voidTile = false;
		UsePic("img/testtile.bmp");
		
		hitShape.MakeSquare(tileSize);
		//hitShape.graphic.visible = true;
		//addChild(hitShape.graphic);
	}
	
	public function InitTL()
	{
		voidTile = false;
		UsePic("img/testdiagtile.bmp");
		
		hitShape.AddPoint( -tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( -tileSize / 2, tileSize / 2);
		
		//hitShape.graphic.visible = true;
		//addChild(hitShape.graphic);
	}
	public function InitTR()
	{
		voidTile = false;
		UsePic("img/testdiagtile.bmp");
		sprite.rotation = 90;
		
		hitShape.AddPoint( -tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, tileSize / 2);
		
		//hitShape.graphic.visible = true;
		//addChild(hitShape.graphic);
	}
	public function InitBL()
	{
		voidTile = false;
		UsePic("img/testdiagtile.bmp");
		sprite.rotation = 270;
		
		hitShape.AddPoint( -tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, tileSize / 2);
		hitShape.AddPoint( -tileSize / 2, tileSize / 2);
		
		//hitShape.graphic.visible = true;
		//addChild(hitShape.graphic);
	}
	public function InitBR()
	{
		voidTile = false;
		UsePic("img/testdiagtile.bmp");
		sprite.rotation = 180;
		
		hitShape.AddPoint( tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, tileSize / 2);
		hitShape.AddPoint( -tileSize / 2, tileSize / 2);
		
		//hitShape.graphic.visible = true;
		//addChild(hitShape.graphic);
	}
	
	public function IsVoidTile():Bool
	{
		return voidTile;
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
}