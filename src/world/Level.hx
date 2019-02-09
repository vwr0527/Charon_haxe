package world;
import openfl.display.Sprite;

/**
 * ...
 * @author Victor Reynolds
 */
class Level extends Sprite
{
	public var xmin:Float;
	public var ymin:Float;
	public var xmax:Float;
	public var ymax:Float;
	
	public var tsize:Float;
	public var xtiles:Int;
	public var ytiles:Int;
	public var tstartx:Float;
	public var tstarty:Float;
	
	public var tiles:Array<Array<LevelTile>>;
	
	public var playerSpawnX:Float;
	public var playerSpawnY:Float;

	public function new() 
	{
		super();
		
		xmin = -480;
		xmax = 480;
		ymin = -270;
		ymax = 270;
		tsize = 32;
		xtiles = 30;
		ytiles = 17;
		tstartx = -480;
		tstarty = -270;
		
		tiles = new Array();
		
		
		for (i in 0...ytiles)
		{
			var newRow = new Array();
			tiles.push(newRow);
			for (j in 0...xtiles)
			{
				var newtile = new LevelTile(tsize);
				if (j == 0 || j == xtiles - 1 || i == 0 || i == ytiles - 1) newtile.InitTest();
				newRow.push(newtile);
				addChild(newtile);
				newtile.x = (j * tsize) + tstartx + tsize / 2;
				newtile.y = (i * tsize) + tstarty + tsize / 2;
			}
		}
		
		tiles[15][28].InitBRTest();
		tiles[15][1].InitBLTest();
		tiles[1][1].InitTLTest();
		tiles[1][28].InitTRTest();
		
		
		playerSpawnX = 0;
		playerSpawnY = 0;
	}
	
	public function GetIndexAtX(xpos:Float):Int
	{
		xpos -= tstartx + tsize / 2;
		xpos /= tsize;
		return Std.int(Math.min(Math.max(Math.round(xpos), 0), xtiles - 1));
	}
	
	public function GetIndexAtY(ypos:Float):Int
	{
		ypos -= tstarty + tsize / 2;
		ypos /= tsize;
		return Std.int(Math.min(Math.max(Math.round(ypos), 0), ytiles - 1));
	}
}