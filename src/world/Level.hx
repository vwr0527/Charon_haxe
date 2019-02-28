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
		currentRoom.Update();
		if (Input.KeyDown(80))
		{
			lastRoomIndex = currentRoom.SwitchToRoomIndex();
			removeChild(currentRoom);
			currentRoom = rooms[lastRoomIndex];
			addChild(currentRoom);
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