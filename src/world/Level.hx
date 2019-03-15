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
	var switchingRoom = false;
	var switchedRoom = false;

	public function new() 
	{
		super();
		rooms = new Array();
	}
	
	public function Update()
	{
		currentRoom.Update();
		switchedRoom = false;
		if (currentRoom.isSwitchingRoom())
		{
			lastRoomIndex = currentRoom.SwitchToRoomIndex();
			removeChild(currentRoom);
			currentRoom = rooms[lastRoomIndex];
			addChild(currentRoom);
			switchingRoom = false;
			switchedRoom = true;
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
	
	public function SwitchRoomPlayerPosX():Float
	{
		return currentRoom.SwitchRoomPlayerPosX(rooms);
	}
	
	public function SwitchRoomPlayerPosY():Float
	{
		return currentRoom.SwitchRoomPlayerPosY(rooms);
	}
	
	public function SwitchedRoom():Bool
	{
		return switchedRoom;
	}
}