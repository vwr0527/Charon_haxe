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
	
	var blinder_left:Sprite;
	var blinder_right:Sprite;
	var blinder_up:Sprite;
	var blinder_down:Sprite;

	public function new() 
	{
		super();
		rooms = new Array();
		bgElements = new Array();
		CreateBlinders();
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
	
	public function UpdateDisplay(cam:Camera)
	{
		currentRoom.SetVisibleTiles(cam);
		
		for (bge in bgElements)
		{
			var ratio = 0.0;
			bge.x = cam.x + (bge.xpos * (1 / cam.GetZZoom()));
			bge.y = cam.y + (bge.ypos * (1 / cam.GetZZoom()));
			bge.scaleX = bge.scaleY = 1 / cam.GetZZoom();
			/*
			bge.x = (Lib.application.window.width / 2) + (bge.xpos);
			bge.y = (Lib.application.window.height / 2) + (bge.ypos);
			*/
		}
		AdjustBlinders(currentRoom);
	}
	
	public function AddBg()
	{
		/*
		var bg:BackgroundElement = new BackgroundElement();
		bg.dist = 10000.0;
		bg.xpos = (Lib.application.window.width / 2) + 0;
		bg.ypos = (Lib.application.window.height / 2) + 0;
		bg.UsePic("img/testbg.png", 0, 2);
		addChildAt(bg, 0);
		bgElements.push(bg);
		
		var bg2:BackgroundElement = new BackgroundElement();
		bg2.dist = 10;
		bg2.xpos = (Lib.application.window.width / 2) + 120;
		bg2.ypos = (Lib.application.window.height / 2) + 40;
		bg2.UsePic("img/spacerock-1.png", 400, 0.2);
		addChildAt(bg2, 1);
		bgElements.push(bg2);
		
		var bg3:BackgroundElement = new BackgroundElement();
		bg3.dist = 5;
		bg3.xpos = (Lib.application.window.width / 2) + -35;
		bg3.ypos = (Lib.application.window.height / 2) + 50;
		bg3.UsePic("img/spacerock-1.png", 300, 0.3);
		addChildAt(bg3, 2);
		bgElements.push(bg3);
		
		var bg4:BackgroundElement = new BackgroundElement();
		bg4.dist = 3.33;
		bg4.xpos = (Lib.application.window.width / 2) + -100;
		bg4.ypos = (Lib.application.window.height / 2) + -15;
		bg4.UsePic("img/spacerock-1.png", 200, 0.4);
		addChildAt(bg4, 3);
		bgElements.push(bg4);
		
		var bg5:BackgroundElement = new BackgroundElement();
		bg5.dist = 2.5;
		bg5.xpos = (Lib.application.window.width / 2) + 20;
		bg5.ypos = (Lib.application.window.height / 2) + -30;
		bg5.UsePic("img/spacerock-1.png", 100, 0.5);
		addChildAt(bg5, 4);
		bgElements.push(bg5);
		*/
		
		var bg:BackgroundElement = new BackgroundElement();
		bg.dist = 10000.0;
		bg.xpos = 0;
		bg.ypos = 0;
		bg.UsePic("img/testbg.png", 0, 2);
		addChildAt(bg, 0);
		bgElements.push(bg);
		
		var bg2:BackgroundElement = new BackgroundElement();
		bg2.dist = 10;
		bg2.xpos = 120;
		bg2.ypos = 40;
		bg2.UsePic("img/spacerock-1.png", 400, 0.2);
		addChildAt(bg2, 1);
		bgElements.push(bg2);
		
		var bg3:BackgroundElement = new BackgroundElement();
		bg3.dist = 5;
		bg3.xpos = -35;
		bg3.ypos = 50;
		bg3.UsePic("img/spacerock-1.png", 300, 0.3);
		addChildAt(bg3, 2);
		bgElements.push(bg3);
		
		var bg4:BackgroundElement = new BackgroundElement();
		bg4.dist = 3.33;
		bg4.xpos = -100;
		bg4.ypos = -15;
		bg4.UsePic("img/spacerock-1.png", 200, 0.4);
		addChildAt(bg4, 3);
		bgElements.push(bg4);
		
		var bg5:BackgroundElement = new BackgroundElement();
		bg5.dist = 2.5;
		bg5.xpos = 20;
		bg5.ypos = -30;
		bg5.UsePic("img/spacerock-1.png", 100, 0.5);
		addChildAt(bg5, 4);
		bgElements.push(bg5);
	}
	
	public function BgSwitchRoom(deltaX:Float, deltaY:Float)
	{
		/*
		for (bge in bgElements)
		{
			bge.xpos -= deltaX;
			bge.ypos -= deltaY;
		}
		*/
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
			
		//DebugPage.Log("Entered room: " + switchRoomIndex);
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
	
	function CreateBlinders() 
	{
		blinder_left = new Sprite();
		blinder_left.graphics.beginFill();
		blinder_left.graphics.drawRect( 0, 0, 100, 100);
		blinder_left.graphics.endFill();
		addChild(blinder_left);
		
		blinder_right = new Sprite();
		blinder_right.graphics.beginFill();
		blinder_right.graphics.drawRect( 0, 0, 100, 100);
		blinder_right.graphics.endFill();
		addChild(blinder_right);
		
		blinder_up = new Sprite();
		blinder_up.graphics.beginFill();
		blinder_up.graphics.drawRect( 0, 0, 100, 100);
		blinder_up.graphics.endFill();
		addChild(blinder_up);
		
		blinder_down = new Sprite();
		blinder_down.graphics.beginFill();
		blinder_down.graphics.drawRect( 0, 0, 100, 100);
		blinder_down.graphics.endFill();
		addChild(blinder_down);
	}
	
	function AdjustBlinders(room:LevelRoom) 
	{
		var thickness:Float = 5000;
		
		blinder_left.x = -thickness;
		blinder_left.width = thickness;
		blinder_left.y = -thickness;
		blinder_left.height = (2 * thickness) + room.ymax;
		
		blinder_right.x = room.xmax;
		blinder_right.width = thickness;
		blinder_right.y = -thickness;
		blinder_right.height = (2 * thickness) + room.ymax;
		
		blinder_up.x = 0;
		blinder_up.width = room.xmax;
		blinder_up.y = -thickness;
		blinder_up.height = thickness;
		
		blinder_down.x = 0;
		blinder_down.width = room.xmax;
		blinder_down.y = room.ymax;
		blinder_down.height = thickness;
	}
	
	function PickBetweenRatio(a:Float, b:Float, ratio:Float):Float
	{
		return a + ((b - a) * ratio);
	}
}
