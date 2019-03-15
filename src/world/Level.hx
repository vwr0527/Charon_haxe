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
	public var previousRoom:LevelRoom;
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
			previousRoom = currentRoom;
			removeChild(currentRoom);
			currentRoom = rooms[currentRoom.SwitchToRoomIndex()];
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
	
	public function SwitchedDoorOrientation():Bool
	{
		return previousRoom.SwitchedDoorOrientation(rooms);
	}
	
	public function SwitchRoomPlayerPosX():Float
	{
		return previousRoom.SwitchRoomPlayerPosX(rooms);
	}
	
	public function SwitchRoomPlayerPosY():Float
	{
		return previousRoom.SwitchRoomPlayerPosY(rooms);
	}
	
	public function SwitchedRoom():Bool
	{
		return switchedRoom;
	}
}