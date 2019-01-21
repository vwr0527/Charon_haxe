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
	
	public var tiles:Array<LevelTile>;

	public function new() 
	{
		super();
		
		xmin = -480;
		xmax = 480;
		ymin = -270;
		ymax = 270;
		
		tiles = new Array();
		
		for (i in 0...30)
		{
			var newtile = new LevelTile();
			tiles.push(newtile);
			addChild(newtile);
			newtile.x = (i * 32) - 480 + 16;
			newtile.y = -270 + 16;
		}
		for (i in 0...30)
		{
			var newtile = new LevelTile();
			tiles.push(newtile);
			addChild(newtile);
			newtile.x = (i * 32) - 480 + 16;
			newtile.y = 274 - 16;
		}
		for (i in 1...16)
		{
			var newtile = new LevelTile();
			tiles.push(newtile);
			addChild(newtile);
			newtile.x = -480 + 16;
			newtile.y = (i * 32) - 270 + 16;
		}
		for (i in 1...16)
		{
			var newtile = new LevelTile();
			tiles.push(newtile);
			addChild(newtile);
			newtile.x = 480 - 16;
			newtile.y = (i * 32) - 270 + 16;
		}
	}
}