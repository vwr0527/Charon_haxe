package world.level;
import menu.DebugPage;
import openfl.Lib;
import openfl.display.Sprite;
import world.level.LevelRoom;
import world.level.tiles.DoorTile;
import world.level.tiles.HDoorTile;
import world.level.tiles.VDoorTile;

/**
 * ...
 * @author Victor Reynolds
 */
class Level extends Sprite
{
	public var rooms:Array<LevelRoom>;
	public var currentRoom:LevelRoom;
	public var previousRoom:LevelRoom;
	
	public var gbgElements:Array<BackgroundElement>; //global background
	
	var switchRoomIndex:Int = 0;
	var switchingRoom:Bool = false;
	var switchedRoom = false;
	
	var targetDoor:Int;
	var targetDoorTileIndex:Int;
	var playerDoorOffsetX:Float;
	var playerDoorOffsetY:Float;
	
	var blinder_left:Sprite;
	var blinder_right:Sprite;
	var blinder_up:Sprite;
	var blinder_down:Sprite;
	
	var backgroundLayer:Sprite;
	var foregroundLayer:Sprite;

	public function new(bg:Sprite, fg:Sprite)
	{
		super();
		rooms = new Array();
		gbgElements = new Array();
		CreateBlinders();
		backgroundLayer = bg;
		foregroundLayer = fg;
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
		
		for (bge in gbgElements)
		{
			bge.Update();
		}
	}
	
	public function UpdateDisplay(cam:Camera)
	{
		currentRoom.SetVisibleTiles(cam);
		
		for (bge in gbgElements)
		{
			var fakex:Float = (bge.xpos - cam.x + (Lib.application.window.width / 2)) * cam.GetDistZZoom(bge.dist);
			var fakey:Float = (bge.ypos - cam.y + (Lib.application.window.height / 2)) * cam.GetDistZZoom(bge.dist);
			var fakesize:Float = bge.size * cam.GetDistZZoom(bge.dist);
			bge.x = cam.x + (fakex * (1 / cam.GetZZoom()));
			bge.y = cam.y + (fakey * (1 / cam.GetZZoom()));
			bge.scaleX = bge.scaleY = fakesize / cam.GetZZoom();
			bge.visible = (cam.z + bge.dist) >= 1.0;
		}
		
		for (bge in currentRoom.bgElements)
		{
			var fakex:Float = (bge.xpos - cam.x + (Lib.application.window.width / 2)) * cam.GetDistZZoom(bge.dist);
			var fakey:Float = (bge.ypos - cam.y + (Lib.application.window.height / 2)) * cam.GetDistZZoom(bge.dist);
			var fakesize:Float = bge.size * cam.GetDistZZoom(bge.dist);
			bge.x = cam.x + (fakex * (1 / cam.GetZZoom()));
			bge.y = cam.y + (fakey * (1 / cam.GetZZoom()));
			bge.scaleX = bge.scaleY = fakesize / cam.GetZZoom();
			bge.visible = (cam.z + bge.dist) >= 1.0;
		}
		
		for (bge in currentRoom.fgElements)
		{
			var fakex:Float = (bge.xpos - cam.x + (Lib.application.window.width / 2)) * cam.GetDistZZoom(bge.dist);
			var fakey:Float = (bge.ypos - cam.y + (Lib.application.window.height / 2)) * cam.GetDistZZoom(bge.dist);
			var fakesize:Float = bge.size * cam.GetDistZZoom(bge.dist);
			bge.x = cam.x + (fakex * (1 / cam.GetZZoom()));
			bge.y = cam.y + (fakey * (1 / cam.GetZZoom()));
			bge.scaleX = bge.scaleY = fakesize / cam.GetZZoom();
			bge.visible = (cam.z + bge.dist) >= 1.0;
		}
		
		AdjustBlinders(currentRoom);
	}
	
	public function AddBg(bge:BackgroundElement)
	{
		backgroundLayer.addChildAt(bge, 0);
		gbgElements.push(bge);
	}
	
	public function BgSwitchRoom(deltaX:Float, deltaY:Float)
	{
		for (bge in gbgElements)
		{
			bge.xpos -= deltaX;
			bge.ypos -= deltaY;
		}
		
		for (bge in previousRoom.bgElements)
		{
			backgroundLayer.removeChild(bge);
		}
		
		for (bge in previousRoom.fgElements)
		{
			foregroundLayer.removeChild(bge);
		}
		
		LoadRoomBgFg();
	}
	
	public function LoadRoomBgFg()
	{
		for (bge in currentRoom.bgElements)
		{
			backgroundLayer.addChild(bge);
		}
		
		for (bge in currentRoom.fgElements)
		{
			foregroundLayer.addChild(bge);
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
	
	public function CreateDoor(firstRoomIndex:Int, firstDoorId:Int, firstDoorTileX:Int, firstDoorTileY:Int, secondDoorId:Int, secondRoomIndex:Int, secondDoorTileX:Int, secondDoorTileY:Int, firstDoorOrientation:String, doorWidth:Int)
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
