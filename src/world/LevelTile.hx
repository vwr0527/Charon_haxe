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
	
	public function new(size:Float) 
	{
		super();
		hitShape = new HitShape();
		tileSize = size;
	}
	
	public function InitTest()
	{
		voidTile = false;
		
		var bmd:BitmapData = openfl.Assets.getBitmapData("img/testtile.bmp");
		var bmd2:BitmapData = new BitmapData(bmd.width, bmd.height);
		bmd2.threshold(bmd, bmd2.rect, new Point(0, 0), "==", 0xff000000, 0x00000000, 0xffffffff, true);
		
		var bitmap = new Bitmap(bmd2);
		var sprite = new Sprite();
		sprite.addChild(bitmap);
		bitmap.x -= bitmap.width * 0.5;
		bitmap.y -= bitmap.height * 0.5;
		bitmap.smoothing = true;
		sprite.scaleY = sprite.scaleX = 1.0;
		addChild(sprite);
		
		hitShape.MakeSquare(tileSize);
		//hitShape.graphic.visible = true;
		//addChild(hitShape.graphic);
	}
	
	public function InitTLTest()
	{
		voidTile = false;
		hitShape.AddPoint( -tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( -tileSize / 2, tileSize / 2);
		hitShape.graphic.visible = true;
		addChild(hitShape.graphic);
	}
	public function InitTRTest()
	{
		voidTile = false;
		hitShape.AddPoint( -tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, tileSize / 2);
		hitShape.graphic.visible = true;
		addChild(hitShape.graphic);
	}
	public function InitBLTest()
	{
		voidTile = false;
		hitShape.AddPoint( -tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, tileSize / 2);
		hitShape.AddPoint( -tileSize / 2, tileSize / 2);
		hitShape.graphic.visible = true;
		addChild(hitShape.graphic);
	}
	public function InitBRTest()
	{
		voidTile = false;
		hitShape.AddPoint( tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, tileSize / 2);
		hitShape.AddPoint( -tileSize / 2, tileSize / 2);
		hitShape.graphic.visible = true;
		addChild(hitShape.graphic);
	}
	
	public function IsVoidTile():Bool
	{
		return voidTile;
	}
	
	public function Blink()
	{
		alpha = Math.random();
	}
}