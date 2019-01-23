package world;
import openfl.display.Sprite;

/**
 * ...
 * @author Victor Reynolds
 */
class Level extends Sprite
{
	public var xmin:Float;
	public var xmax:Float;
	public var ymin:Float;
	public var ymax:Float;
	
	public var tiles:Array<Array<LevelTile>>;

	public function new() 
	{
		super();
		
		xmin = -480;
		xmax = 480;
		ymin = -270;
		ymax = 270;
		
		tiles = new Array();
		
		
		for (i in 0...17)
		{
			var newRow = new Array();
			tiles.push(newRow);
			for (j in 0...30)
			{
				var newtile = new LevelTile();
				if (j == 0 || j == 29 || i == 0 || i == 16) newtile.InitTest();
				newRow.push(newtile);
				addChild(newtile);
				newtile.x = (j * 32) - 480 + 16;
				newtile.y = (i * 32) - 270 + 16;
			}
		}
	}
	
	public function TestTileAt(xpos:Float, ypos:Float)
	{
		xpos += 480 - 16;
		ypos += 270 - 16;
		xpos /= 32;
		ypos /= 32;
		
		var yi = Math.round(ypos);
		var xi = Math.round(xpos);
		
		var selectTile:LevelTile = tiles[yi][xi];
		if (/*xi <= 30 && yi <= 16 && */selectTile != null)
			selectTile.Blink();
	}
}