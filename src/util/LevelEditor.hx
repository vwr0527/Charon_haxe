package util;
import haxe.Json;
import haxe.ds.ArraySort;
import openfl.Assets;
import openfl.display.Sprite;
import world.Camera;
import world.Enemy;
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
	
	public function new()
	{
		active = false;
		
		leveldata =  {
			tileDef : new Array<String>(),
			rooms : new Array<LevelRoomData>(),
			gbg : new Array<DecorData>()//global background
		};
	}
	
	public function Update(cam:Camera)
	{
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
		
		cam.x += cam_vx;
		cam.y += cam_vy;
		cam.z += cam_vz;
		
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
		
		cam_vx *= 0.8;
		cam_vy *= 0.8;
		cam_vz *= 0.8;
	}
		
	public function ReadLevel(levelname:String)
	{
		leveltext = Assets.getText(levelname);
		leveldata = Json.parse(leveltext);
	}
	
	public function OutputString():String
	{
		return Json.stringify(leveldata);
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
		var level:Level = new Level(bg, fg);
		
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
		return level;
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