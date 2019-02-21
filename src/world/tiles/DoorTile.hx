package world.tiles;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import world.LevelTile;

/**
 * ...
 * @author ...
 */
class DoorTile extends LevelTile
{
	public function new(size:Float) 
	{
		super(size);
	}
	
	public override function Init()
	{
		voidTile = false;
		
		var bmd:BitmapData = openfl.Assets.getBitmapData("img/testdoor.bmp");
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
}