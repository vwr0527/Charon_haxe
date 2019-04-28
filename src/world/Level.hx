package world;
import openfl.display.Sprite;
import world.LevelRoom;
import world.tiles.DoorTile;
import world.tiles.HDoorTile;
import world.tiles.VDoorTile;

/**
 * ...
 * @author Victor Reynolds
 */
class Level extends Sprite
{
	public var rooms:Array<LevelRoom>;
	public var currentRoom:LevelRoom;
	public var previousRoom:LevelRoom;
	
	var switchRoomIndex:Int = 0;
	var switchingRoom:Bool = false;
	var switchedRoom = false;
	
	var targetDoor:String;
	var targetDoorTileIndex:Int;
	var playerDoorOffsetX:Float;
	var playerDoorOffsetY:Float;

	public function new() 
	{
		super();
		rooms = new Array();
	}
	
	public function Update()
	{
		currentRoom.Update();
		switchedRoom = false;
		if (switchingRoom)
		{
			previousRoom = currentRoom;
			removeChild(currentRoom);
			currentRoom = rooms[switchRoomIndex];
			addChild(currentRoom);
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
	
	public function EnteredDoor(door:DoorTile, offset:Float) 
	{
		switchingRoom = true;
		switchRoomIndex = currentRoom.doors[door.GetID()].targetRoom;
		targetDoor = currentRoom.doors[door.GetID()].targetDoor;
		targetDoorTileIndex = currentRoom.doors[door.GetID()].doorTiles.indexOf(door);
		
		var enteredDoorVertical:Bool = true;
		
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
		
		if (rooms[switchRoomIndex].doors[targetDoor].doorTiles[targetDoorTileIndex].IsVertical() != enteredDoorVertical)
		{
			var temp = playerDoorOffsetX;
			playerDoorOffsetX = playerDoorOffsetY;
			playerDoorOffsetY = temp;
		}
	}
	
	public function SwitchRoomPlayerPosX():Float
	{
		switchingRoom = false;
		return rooms[switchRoomIndex].doors[targetDoor].doorTiles[targetDoorTileIndex].x + playerDoorOffsetX + rooms[switchRoomIndex].doors[targetDoor].enterDirX;
	}
	
	public function SwitchRoomPlayerPosY():Float
	{
		switchingRoom = false;
		return rooms[switchRoomIndex].doors[targetDoor].doorTiles[targetDoorTileIndex].y + playerDoorOffsetY + rooms[switchRoomIndex].doors[targetDoor].enterDirY;
	}
	
	public function SwitchedRoom():Bool
	{
		return switchedRoom;
	}
	
	public function CreateDoor(firstRoomIndex:Int, firstDoorId:String, firstDoorTileX:Int, firstDoorTileY:Int, secondDoorId:String, secondRoomIndex:Int, secondDoorTileX:Int, secondDoorTileY:Int, firstDoorOrientation:String, doorWidth:Int)
	{
		var room1 = rooms[firstRoomIndex];
		var room2 = rooms[secondRoomIndex];
		for (i in 0...doorWidth)
		{
			if (firstDoorOrientation == "Right" || firstDoorOrientation == "Left")
			{
				room1.SetDoor(new VDoorTile(firstDoorId), firstDoorTileX, firstDoorTileY + i);
				room2.SetDoor(new VDoorTile(secondDoorId), secondDoorTileX, secondDoorTileY + i);
			}
			else
			{
				room1.SetDoor(new HDoorTile(firstDoorId), firstDoorTileX + i, firstDoorTileY);
				room2.SetDoor(new HDoorTile(secondDoorId), secondDoorTileX + i, secondDoorTileY);
			}
		}
		room1.doors[firstDoorId].targetDoor = secondDoorId;
		room1.doors[firstDoorId].targetRoom = secondRoomIndex;
		room2.doors[secondDoorId].targetDoor = firstDoorId;
		room2.doors[secondDoorId].targetRoom = firstRoomIndex;
		
		if (firstDoorOrientation == "Right")
		{
			room1.doors[firstDoorId].enterDirX = -1;
			room1.doors[firstDoorId].enterDirY = 0;
			room2.doors[secondDoorId].enterDirX = 1;
			room2.doors[secondDoorId].enterDirY = 0;
		}
		else if (firstDoorOrientation == "Down")
		{
			room1.doors[firstDoorId].enterDirX = 0;
			room1.doors[firstDoorId].enterDirY = -1;
			room2.doors[secondDoorId].enterDirX = 0;
			room2.doors[secondDoorId].enterDirY = 1;
		}
		else if (firstDoorOrientation == "Left")
		{
			room1.doors[firstDoorId].enterDirX = 1;
			room1.doors[firstDoorId].enterDirY = 0;
			room2.doors[secondDoorId].enterDirX = -1;
			room2.doors[secondDoorId].enterDirY = 0;
		}
		else if (firstDoorOrientation == "Up")
		{
			room1.doors[firstDoorId].enterDirX = 0;
			room1.doors[firstDoorId].enterDirY = 1;
			room2.doors[secondDoorId].enterDirX = 0;
			room2.doors[secondDoorId].enterDirY = -1;
		}
	}
}
