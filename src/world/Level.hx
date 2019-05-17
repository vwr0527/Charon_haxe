package world;
import menu.DebugPage;
import openfl.Lib;
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
	
	var bgElements:Array<BackgroundElement>;

	public function new() 
	{
		super();
		rooms = new Array();
		bgElements = new Array();
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
	
	public function UpdateBG()
	{
		for (bge in bgElements)
		{
			bge.x = PickBetweenRatio(((Lib.application.window.width / 2) - parent.x) * (1 / parent.scaleX), bge.xpos, bge.dist);
			bge.y = PickBetweenRatio(((Lib.application.window.height / 2) - parent.y) * (1 / parent.scaleX), bge.ypos, bge.dist);
		}
	}
	
	public function AddBg()
	{
		var bg:BackgroundElement = new BackgroundElement();
		bg.dist = 0.0;
		bg.xpos = Lib.application.window.width / 2;
		bg.ypos = Lib.application.window.height / 2;
		bg.UsePic("img/testbg.png", 0, 2);
		addChildAt(bg, 0);
		bgElements.push(bg);
		
		var bg2:BackgroundElement = new BackgroundElement();
		bg2.dist = 0.1;
		bg2.xpos = (Lib.application.window.width / 2) + 1200;
		bg2.ypos = (Lib.application.window.height / 2) + 400;
		bg2.UsePic("img/spacerock-1.png", 400, 0.2);
		addChildAt(bg2, 1);
		bgElements.push(bg2);
		
		var bg3:BackgroundElement = new BackgroundElement();
		bg3.dist = 0.2;
		bg3.xpos = (Lib.application.window.width / 2) - 350;
		bg3.ypos = (Lib.application.window.height / 2) + 500;
		bg3.UsePic("img/spacerock-1.png", 300, 0.3);
		addChildAt(bg3, 2);
		bgElements.push(bg3);
		
		var bg4:BackgroundElement = new BackgroundElement();
		bg4.dist = 0.3;
		bg4.xpos = (Lib.application.window.width / 2) - 1000;
		bg4.ypos = (Lib.application.window.height / 2) - 150;
		bg4.UsePic("img/spacerock-1.png", 200, 0.4);
		addChildAt(bg4, 3);
		bgElements.push(bg4);
		
		var bg5:BackgroundElement = new BackgroundElement();
		bg5.dist = 0.4;
		bg5.xpos = (Lib.application.window.width / 2) + 200;
		bg5.ypos = (Lib.application.window.height / 2) - 300;
		bg5.UsePic("img/spacerock-1.png", 100, 0.5);
		addChildAt(bg5, 4);
		bgElements.push(bg5);
	}
	
	public function BgSwitchRoom(deltaX:Float, deltaY:Float)
	{
		for (bge in bgElements)
		{
			bge.xpos -= deltaX;
			bge.ypos -= deltaY;
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
		if (switchingRoom == true) return;
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
			
		DebugPage.Log("Entered room: " + switchRoomIndex);
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
	
	function PickBetweenRatio(a:Float, b:Float, ratio:Float):Float
	{
		return a + ((b - a) * ratio);
	}
}
