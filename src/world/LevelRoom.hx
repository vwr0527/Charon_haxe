package world;
import openfl.display.Sprite;

/**
 * ...
 * @author Victor Reynolds
 */
class LevelRoom extends Sprite
{
	public var xmin:Float;
	public var ymin:Float;
	public var xmax:Float;
	public var ymax:Float;
	
	var tsize:Float;
	var xtiles:Int;
	var ytiles:Int;
	var tstartx:Float;
	var tstarty:Float;
	
	public var tiles:Array<Array<LevelTile>>;
	
	public var playerSpawnX:Float;
	public var playerSpawnY:Float;
	
	var switchingRoom:Bool = false;
	var switchRoomIndex:Int = 0;

	public function new(x_min:Float, x_max:Float, y_min:Float, y_max:Float, tile_size:Float, num_x_tiles:Int, num_y_tiles:Int, tile_start_x:Float, tile_start_y:Float) 
	{
		super();
		xmin = x_min;
		xmax = x_max;
		ymin = y_min;
		ymax = y_max;
		tsize = tile_size;
		xtiles = num_x_tiles;
		ytiles = num_y_tiles;
		tstartx = tile_start_x;
		tstarty = tile_start_y;
		tiles = new Array();
		for (i in 0...num_y_tiles)
		{
			var newRow = new Array();
			tiles.push(newRow);
			for (j in 0...num_x_tiles)
			{
				newRow.push(null);
			}
		}
	}
	
	public function Update() 
	{
		if (Input.KeyDown(80))
		{
			switchingRoom = true;
			if (switchRoomIndex == 0)
			{
				switchRoomIndex = 1;
			}
			else
			{
				switchRoomIndex = 0;
			}
		}
	}
	
	public function SetTile(tile:LevelTile, xi:Int, yi:Int)
	{
		if (tiles[yi][xi] != null) removeChild(tiles[yi][xi]);
		tiles[yi][xi] = tile;
		addChild(tile);
		tiles[yi][xi].x = (xi * tsize) + tstartx + tsize / 2;
		tiles[yi][xi].y = (yi * tsize) + tstarty + tsize / 2;
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
	
	public function IsSwitchingRoom():Bool
	{
		return switchingRoom;
	}
	
	public function SwitchToRoomIndex():Int
	{
		switchingRoom = false;
		return switchRoomIndex;
	}
}