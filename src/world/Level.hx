package world;
import openfl.display.Sprite;
import world.LevelRoom;

/**
 * ...
 * @author Victor Reynolds
 */
class Level extends Sprite
{
	public var rooms:Array<LevelRoom>;
	public var currentRoom:LevelRoom;
	public var lastRoomIndex:Int;

	public function new() 
	{
		super();
		rooms = new Array();
	}
	
	public function Update()
	{
		if (currentRoom.IsSwitchingRoom())
		{
			lastRoomIndex = currentRoom.SwitchToRoomIndex();
			currentRoom = rooms[lastRoomIndex];
		}
	}
	
	public function StartRoom():LevelRoom
	{
		return rooms[0];
	}
	
	public function CurrentRoom():LevelRoom
	{
		return currentRoom;
	}
}