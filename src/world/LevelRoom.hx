package world;
import openfl.display.Sprite;
import world.LevelTile;
import world.tiles.DoorTile;

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
	public var doors:Array<DoorController>;
	
	public var playerSpawnX:Float;
	public var playerSpawnY:Float;
	
	public var switchRoomIndex:Int = 0;
	private var switchingRoom:Bool = false;

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
		doors = new Array();
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
		for (i in 0...ytiles)
		{
			for (j in 0...xtiles)
			{
				if (tiles[i][j] != null) tiles[i][j].Update();
			}
		}
		for (i in 0...doors.length)
		{
			doors[i].Update();
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
	
	public function SetDoor(dtile:DoorTile, xi:Int, yi:Int)
	{
		SetTile(dtile, xi, yi);
		var doorIndex:Int = dtile.GetID();
		while (doors.length <= doorIndex)
		{
			doors.push(new DoorController());
		}
		doors[doorIndex].doorTiles.push(dtile);
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
	
	public function SwitchToRoomIndex():Int
	{
		return switchRoomIndex;
	}
	
	var enteredDoorVertical:Bool;
	var targetDoor:Int;
	var targetDoorTileIndex:Int;
	var playerDoorOffsetX:Float;
	var playerDoorOffsetY:Float;
	var doorSwitchingOrientation:Bool;
	
	public function EnteredDoor(door:DoorTile, offset:Float) 
	{
		switchingRoom = true;
		switchRoomIndex = doors[door.GetID()].targetRoom;
		targetDoor = doors[door.GetID()].targetDoor;
		targetDoorTileIndex = doors[door.GetID()].doorTiles.indexOf(door);
		if (door.IsVertical()) 
		{
			enteredDoorVertical = true;
			playerDoorOffsetX = 0;
			playerDoorOffsetY = offset;
		}
		else
		{
			enteredDoorVertical = false;
			playerDoorOffsetX = offset;
			playerDoorOffsetY = 0;
		}
	}
	
	public function SwitchedDoorOrientation(rooms:Array<LevelRoom>):Bool
	{
		doorSwitchingOrientation = rooms[switchRoomIndex].doors[targetDoor].doorTiles[targetDoorTileIndex].IsVertical() != enteredDoorVertical;
		if (doorSwitchingOrientation)
		{
			var temp = playerDoorOffsetX;
			playerDoorOffsetX = playerDoorOffsetY;
			playerDoorOffsetY = temp;
		}
		return doorSwitchingOrientation;
	}
	
	public function SwitchRoomPlayerPosX(rooms:Array<LevelRoom>):Float
	{
		switchingRoom = false;
		return rooms[switchRoomIndex].doors[targetDoor].doorTiles[targetDoorTileIndex].x + playerDoorOffsetX;
	}
	
	public function SwitchRoomPlayerPosY(rooms:Array<LevelRoom>):Float
	{
		switchingRoom = false;
		return rooms[switchRoomIndex].doors[targetDoor].doorTiles[targetDoorTileIndex].y + playerDoorOffsetY;
	}
	
	public function isSwitchingRoom():Bool
	{
		return switchingRoom;
	}
}