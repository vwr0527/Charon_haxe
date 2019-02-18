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
	
	public var tsize:Float;
	public var xtiles:Int;
	public var ytiles:Int;
	public var tstartx:Float;
	public var tstarty:Float;
	
	public var tiles:Array<Array<LevelTile>>;
	
	public var playerSpawnX:Float;
	public var playerSpawnY:Float;
	
	var switchingRoom:Bool = false;
	var switchRoomIndex:Int = 0;

	public function new() 
	{
		super();
		tiles = new Array();
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
		return switchRoomIndex;
	}
}