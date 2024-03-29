package util;
import haxe.Json;
import haxe.ds.ArraySort;
import openfl.Assets;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.geom.Point;
import world.Camera;
import world.Enemy;
import world.HitShape;
import world.level.BackgroundElement;
import world.level.Level;
import world.level.LevelRoom;
import world.level.LevelTile;

/**
 * ...
 * @author 
 */
class LevelEditor 
{
	public static var active:Bool;
	var leveltext:String;
	var level:Level;
	var leveldata:LevelData;
	var cam_vx = 0.0;
	var cam_vy = 0.0;
	var cam_vz = 0.0;
	var camspeed = 2.0;
	
	var currentlySelectedBGE:BackgroundElement;
	var selectedOneBGE:Bool;
	var currentPoint:Int = 0;
	var currentlyCreating:HitShape;
	var tileHighlighted:Shape;
	var currentTile:Shape;
	var tileSelected:Bool;
	var selectedTileX:Int;
	var selectedTileY:Int;
	
	public function new()
	{
		active = false;
		
		leveldata =  {
			tileDef : new Array<String>(),
			rooms : new Array<LevelRoomData>(),
			gbg : new Array<DecorData>()//global background
		};
		
		currentlyCreating = new HitShape();
		currentlyCreating.AddPoint(0, 0);
		currentlyCreating.AddPoint(0, 0);
		currentlyCreating.AddPoint(0, 0);
		
		tileHighlighted = new Shape();
		tileHighlighted.graphics.beginFill (0xFFFFFF, 0.25);
		tileHighlighted.graphics.drawRect( -10, -10, 20, 20);
		tileHighlighted.graphics.endFill();
		
		currentTile = new Shape();
		currentTile.graphics.beginFill (0xFFFFFF, 0.25);
		currentTile.graphics.drawRect( -10, -10, 20, 20);
		currentTile.graphics.endFill();
		
		tileSelected = false;
	}
		
	public function ReadLevel(levelname:String)
	{
		leveltext = Assets.getText(levelname);
		leveldata = Json.parse(leveltext);
	}
	
	public function Update(cam:Camera)
	{
		var t = Math.max(Math.min(60 / Main.getFPS(), 2), 0.25);
		
		if (Input.KeyHeld(65))
		{
			cam_vx -= camspeed;
		}
		if (Input.KeyHeld(68))
		{
			cam_vx += camspeed;
		}
		if (Input.KeyHeld(87))
		{
			cam_vy -= camspeed;
		}
		if (Input.KeyHeld(83))
		{
			cam_vy += camspeed;
		}
		if (Input.KeyHeld(90))
		{
			cam_vz += camspeed / 4;
		}
		if (Input.KeyHeld(88))
		{
			cam_vz -= camspeed / 4;
		}
		
		cam.x += cam_vx * t;
		cam.y += cam_vy * t;
		cam.z += cam_vz * t;
		
		if (cam.z < 5.0)
		{
			cam_vz = 0;
			cam.z = 5.0;
		}
		if (cam.z > 500.0)
		{
			cam_vz = 0;
			cam.z = 500.0;
		}
		
		cam_vx *= 1 / Math.pow(10, 0.1 * t);
		cam_vy *= 1 / Math.pow(10, 0.1 * t);
		cam_vz *= 1 / Math.pow(10, 0.1 * t);
	}
	
	public function CreateBGE(decordata:DecorData):BackgroundElement
	{
		var bge = new BackgroundElement();
		bge.dist = decordata.z;
		bge.xpos = decordata.x;
		bge.ypos = decordata.y;
		var splitstring = decordata.data.split(",");
		bge.UsePic(splitstring[0], Std.parseFloat(splitstring[1]),  Std.parseFloat(splitstring[2]));
		return bge;
	}
	
	public function BuildLevel(bg:Sprite, fg:Sprite):Level
	{
		level = new Level(bg, fg);
		
		ArraySort.sort(leveldata.gbg, function(a, b):Int{return Std.int(a.z - b.z); });
		
		for (decordata in leveldata.gbg)
		{
			level.AddBg(CreateBGE(decordata));
		}
		
		for (roomdata in leveldata.rooms)
		{
			var num_x_tiles:Int = roomdata.tileMap[0].length;
			var num_y_tiles:Int = roomdata.tileMap.length;
			var room:LevelRoom = new LevelRoom(num_x_tiles, num_y_tiles);
			for (i in 0...room.tiles.length)
			{
				for (j in 0...room.tiles[0].length)
				{
					var tileindex = roomdata.tileMap[i][j] - 1;
					if (tileindex >= 0)
					{
						var tiledata = leveldata.tileDef[tileindex];
						
						if (tiledata == "black")
						{
							room.SetBlackTile(j, i);
						}
						else
						{
							room.SetTile(LevelTile.CreateTile(tiledata), j, i);
						}
					}
				}
			}
			for (entdata in roomdata.entities)
			{
				if (entdata.data == "PlayerSpawn")
				{
					room.playerSpawnX = entdata.x;
					room.playerSpawnY = entdata.y;
					level.currentRoom = room;
				}
				if (entdata.data == "Enemy1")
				{
					var enemy:Enemy = new Enemy();
					enemy.x = entdata.x;
					enemy.y = entdata.y;
					enemy.age = Std.int(Math.random() * 1000);
					room.ents.push(enemy);
				}
			}
			
			if (roomdata.bg != null)
			{
				ArraySort.sort(roomdata.bg, function(a, b):Int{return Std.int(a.z - b.z); });
				for (decordata in roomdata.bg)
				{
					room.AddBg(CreateBGE(decordata));
				}
			}
			
			if (roomdata.fg != null)
			{
				ArraySort.sort(roomdata.fg, function(a, b):Int{return Std.int(a.z - b.z); });
				for (decordata in roomdata.fg)
				{
					room.AddFg(CreateBGE(decordata));
				}
			}
			
			level.rooms.push(room);
		}
		
		for (roomindex in 0...leveldata.rooms.length)
		{
			var roomdata = leveldata.rooms[roomindex];
			for (doorindex in 0...roomdata.doors.length)
			{
				var firstDoor = roomdata.doors[doorindex];
				var firstDoorInfo = firstDoor.data.split(",");
				
				if (firstDoorInfo.length != 4) continue;
				
				var firstRoomIndex = roomindex;
				var firstDoorId = doorindex;
				var firstDoorTileX = firstDoor.x;
				var firstDoorTileY = firstDoor.y;
				var secondDoorId = Std.parseInt(firstDoorInfo[1]);
				var secondRoomIndex = Std.parseInt(firstDoorInfo[0]) - 1;
				var secondDoorTileX = leveldata.rooms[secondRoomIndex].doors[secondDoorId].x;
				var secondDoorTileY = leveldata.rooms[secondRoomIndex].doors[secondDoorId].y;
				var firstDoorOrientation = firstDoorInfo[2];
				var doorWidth = Std.parseInt(firstDoorInfo[3]);
				level.CreateDoor(firstRoomIndex, firstDoorId, firstDoorTileX, firstDoorTileY, secondDoorId, secondRoomIndex, secondDoorTileX, secondDoorTileY, firstDoorOrientation, doorWidth);
			}
		}
		
		level.addChild(level.currentRoom);
		level.LoadRoomBgFg();
		level.addChild(currentlyCreating.graphic);
		level.addChild(currentTile);
		level.addChild(tileHighlighted);
		
		return level;
	}
	
	public function OutputString():String
	{
		return Json.stringify(leveldata);
	}
	
	public function BGESelector()
	{
		var xpos = level.root.mouseX;
		var ypos = level.root.mouseY;
		
		selectedOneBGE = false;
		for (bge in level.gbgElements)
		{
			if (bge.dist == 10000)
			{
				continue;
			}
			SelectOneBGE(bge, xpos, ypos);
		}
		for (bge in level.currentRoom.bgElements)
		{
			SelectOneBGE(bge, xpos, ypos);
		}
		for (bge in level.currentRoom.fgElements)
		{
			SelectOneBGE(bge, xpos, ypos);
		}
		if (Input.MouseUp() && !selectedOneBGE)
		{
			currentlySelectedBGE = null;
		}
		if (currentlySelectedBGE != null)
		{
			currentlySelectedBGE.ShowOutline();
		}
	}
	
	function SelectOneBGE(bge:BackgroundElement, xpos:Float, ypos:Float) //helper function
	{
		if (bge.hitTestPoint(xpos, ypos))
		{
			if (bge != currentlySelectedBGE)
			{
				bge.ShowOutline();
			}
			if (Input.MouseUp())
			{
				currentlySelectedBGE = bge;
				trace(currentlySelectedBGE.dist);
				selectedOneBGE = true;
			}
		} else {
			if (bge != currentlySelectedBGE)
			{
				bge.HideOutline();
			}
		}
	}
	
	public function DeselectAllBGE()
	{
		for (bge in level.gbgElements)
		{
			bge.HideOutline();
		}
		for (bge in level.currentRoom.bgElements)
		{
			bge.HideOutline();
		}
		for (bge in level.currentRoom.fgElements)
		{
			bge.HideOutline();
		}
		currentlySelectedBGE = null;
	}
	
	public function TriangleCreator()
	{
		var xpos = level.mouseX;
		var ypos = level.mouseY;
		
		if (Input.MouseDown())
		{
			if (currentPoint == 0)
			{
				currentlyCreating.SetPoint(1, xpos - 2, ypos + 2);
				currentlyCreating.SetPoint(2, xpos + 2, ypos + 2);
			}
			currentlyCreating.SetPoint(currentPoint, xpos, ypos);
		}
		if (Input.MouseHeld())
		{
			if (currentPoint == 0)
			{
				currentlyCreating.SetPoint(1, xpos - 2, ypos + 2);
				currentlyCreating.SetPoint(2, xpos + 2, ypos + 2);
			}
			currentlyCreating.SetPoint(currentPoint, xpos, ypos);
		}
		if (Input.MouseUp())
		{
			if (currentPoint == 2)
			{
				level.currentRoom.AddTriangle(currentlyCreating.GetX(0), currentlyCreating.GetY(0), currentlyCreating.GetX(1), currentlyCreating.GetY(1), currentlyCreating.GetX(2), currentlyCreating.GetY(2));
			}
			currentPoint += 1;
			if (currentPoint >= 3) currentPoint = 0;
		}
		
		if (currentPoint != 0)
		{
			currentlyCreating.graphic.visible = true;
		}
	}
	
	public function CancelTriangleCreator()
	{
		currentPoint = 0;
		currentlyCreating.graphic.visible = false;
	}
	
	public function TileSelector()
	{
		if (level == null || level.currentRoom == null) return;
		
		var tileWidth = LevelTile.size;
		var tileHeight = LevelTile.size;
		
		var highlightedTileX = level.currentRoom.GetIndexAtX(level.mouseX);
		var highlightedTileY = level.currentRoom.GetIndexAtY(level.mouseY);
		
		tileHighlighted.x = 1.0 * ((highlightedTileX * tileWidth) + (tileWidth / 2));
		tileHighlighted.y = 1.0 * ((highlightedTileY * tileHeight) + (tileHeight / 2));
		tileHighlighted.width = tileWidth;
		tileHighlighted.height = tileHeight;
		tileHighlighted.visible = true;
		
		if (Input.MouseDown() || Input.MouseHeld() || Input.MouseUp())
		{
			currentTile.visible = true;
			currentTile.x = tileHighlighted.x;
			currentTile.y = tileHighlighted.y;
			currentTile.width = tileHighlighted.width;
			currentTile.height = tileHighlighted.height;
			
			if (Input.MouseUp())
			{
				if (tileSelected && selectedTileX == highlightedTileX && selectedTileY == highlightedTileY)
				{
					tileSelected = false;
				}
				else
				{
					tileSelected = true;
					selectedTileX = highlightedTileX;
					selectedTileY = highlightedTileY;
				}
			}
		}
		
		currentTile.visible = tileSelected;
	}
	
	public function CancelTileSelect()
	{
		tileSelected = false;
		tileHighlighted.visible = false;
		currentTile.visible = false;
	}
}

typedef LevelData =
{
	var tileDef:Array<String>;
	var rooms:Array<LevelRoomData>;
	var gbg:Array<DecorData>;
}

typedef LevelRoomData =
{
	var tileMap:Array<Array<Int>>;
	var entities:Array<EntityData>;
	var doors:Array<DoorData>;
	var fg:Array<DecorData>;
	var bg:Array<DecorData>;
}

typedef DecorData =
{
	var x:Float;
	var y:Float;
	var z:Float;
	var data:String;
}

typedef EntityData =
{
	var x:Float;
	var y:Float;
	var data:String;
}

typedef DoorData =
{
	var x:Int;
	var y:Int;
	var data:String;
}