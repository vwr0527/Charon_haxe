package util;
import haxe.Json;
import haxe.ds.Vector;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.utils.Dictionary;
import world.Enemy;
import world.level.Level;
import world.level.LevelRoom;
import world.level.LevelTile;

/**
 * ...
 * @author 
 */
class LevelParser 
{
	var leveltext:Array<String>;
	var level:Level;
	var leveldata:LevelData;
	
	public function new()
	{
		leveltext = new Array<String>();
		leveldata = {
			tilesDictionary : new Dictionary<String,String>(),
			entitiesDictionary : new Dictionary<String,String>(),
			roomsDictionary : new Dictionary<String,Array<Array<String>>>(),
			roomDoorsDictionary : new Dictionary<String,Dictionary<String,String>>()
		};
	}
		
	public function ReadLevel(levelname:String)
	{
		leveltext = Assets.getText(levelname).split("\n");
		var currentSection:String = "none";
		var currentRoom:String = "none";
		var currentDoorsDictionary:Dictionary<String,String> = new Dictionary<String,String>();
		var currentRoomContent:Array<Array<String>> = new Array<Array<String>>();
		var startedReadingCurrentRoom:Bool = false;
		var finishedReadingCurrentRoom:Bool = false;
		var startedReadingCurrentRoomDoors:Bool = false;
		var finishedReadingCurrentRoomDoors:Bool = false;
		leveltext.push("");
		
		for (line in leveltext)
		{
			if (line.charCodeAt(line.length - 1) == 13) line = line.substr(0, line.length - 1); //remove last character if it's "\n"
			if (line.indexOf("Tiles") != -1)
			{
				currentSection = "Tiles";
				continue;
			}
			if (line.indexOf("Entities") != -1)
			{
				currentSection = "Entities";
				continue;
			}
			if (line.indexOf("Room") != -1)
			{
				currentSection = "Room";
				currentRoom = line.substring(line.indexOf("Room ") + 5, line.indexOf(":"));
				startedReadingCurrentRoom = false;
				finishedReadingCurrentRoom = false;
				currentRoomContent = new Array<Array<String>>();
				continue;
			}
			if (line.indexOf("Doors") != -1)
			{
				currentSection = "Doors";
				startedReadingCurrentRoomDoors = false;
				finishedReadingCurrentRoomDoors = false;
				currentDoorsDictionary = new Dictionary<String,String>();
				continue;
			}
			
			if (currentSection == "Tiles")
			{
				if (line.indexOf(": ") == -1) continue;
				
				var splitLine = line.split(": ");
				leveldata.tilesDictionary.set(splitLine[0], splitLine[1]);
				
				continue;
			}
			if (currentSection == "Entities")
			{
				if (line.indexOf(": ") == -1) continue;
				
				var splitLine = line.split(": ");
				leveldata.entitiesDictionary.set(splitLine[0], splitLine[1]);
				
				continue;
			}
			if (currentSection == "Room")
			{
				if (finishedReadingCurrentRoom) continue;
				if (line.indexOf(",") == -1 && !startedReadingCurrentRoom) continue;
				if (line.indexOf(",") == -1 && startedReadingCurrentRoom)
				{
					leveldata.roomsDictionary.set(currentRoom, currentRoomContent);
					finishedReadingCurrentRoom = true;
					continue;
				}
				if (line.indexOf(",") != -1)
				{
					startedReadingCurrentRoom = true;
					var splitLine = line.split(",");
					currentRoomContent.push(splitLine);
				}
				
				continue;
			}
			if (currentSection == "Doors")
			{
				if (finishedReadingCurrentRoomDoors) continue;
				if (line.indexOf(":") == -1 && !startedReadingCurrentRoomDoors) continue;
				if (line.indexOf(":") == -1 && startedReadingCurrentRoomDoors)
				{
					leveldata.roomDoorsDictionary.set(currentRoom, currentDoorsDictionary);
					finishedReadingCurrentRoomDoors = true;
					continue;
				}
				if (line.indexOf(":") != -1)
				{
					startedReadingCurrentRoomDoors = true;
					var splitLine = line.split(":");
					if (splitLine[1].charAt(0) == " ") splitLine[1] = splitLine[1].substr(1); //remove first character if it's " "
					currentDoorsDictionary.set(splitLine[0],splitLine[1]);
				}
				
				continue;
			}
		}
	}
	
	public function BuildLevel(bg:Sprite, fg:Sprite):Level
	{
		level = new Level(bg, fg);
		
		var roomKeyArray:Array<String> = new Array<String>();
		var doorLocations:Dictionary<String,Dictionary<String,Array<Int>>> = new Dictionary<String,Dictionary<String,Array<Int>>>(); // roomname, doorname, x, y
		
		for (roomKey in leveldata.roomsDictionary)
		{
			roomKeyArray.push(roomKey);
			var num_x_tiles:Int = leveldata.roomsDictionary[roomKey][0].length;
			var num_y_tiles:Int = leveldata.roomsDictionary[roomKey].length;
			
			var room:LevelRoom = new LevelRoom(num_x_tiles, num_y_tiles);
			
			for (j in 0...num_y_tiles)
			{
				for (i in 0...num_x_tiles)
				{
					var str_at_loc:String = leveldata.roomsDictionary[roomKey][j][i];
					
					if (leveldata.entitiesDictionary.exists(str_at_loc))
					{
						if (leveldata.entitiesDictionary[str_at_loc] == "PlayerSpawn")
						{
							room.playerSpawnX = (i * LevelTile.size) + (LevelTile.size / 2);
							room.playerSpawnY = (j * LevelTile.size) + (LevelTile.size / 2);
						}
						else if (leveldata.entitiesDictionary[str_at_loc] == "Enemy1")
						{
							var enemy:Enemy = new Enemy();
							enemy.x = (i * LevelTile.size) + (LevelTile.size / 2);
							enemy.y = (j * LevelTile.size) + (LevelTile.size / 2);
							enemy.age = Std.int(Math.random() * 1000);
							room.ents.push(enemy);
						}
					}
					else if (leveldata.roomDoorsDictionary[roomKey].exists(str_at_loc))
					{
						if (!doorLocations.exists(roomKey))
						{
							doorLocations.set(roomKey, new Dictionary<String,Array<Int>>());
						}
						if (!doorLocations[roomKey].exists(str_at_loc))
						{
							doorLocations[roomKey].set(str_at_loc, new Array<Int>());
						}
						if (doorLocations[roomKey][str_at_loc].length == 0)
						{
							doorLocations[roomKey][str_at_loc].push(i);
							doorLocations[roomKey][str_at_loc].push(j);
						}
						else
						{
							trace("Error, this room already has a door with that name");
						}
					}
					else if (leveldata.tilesDictionary.exists(str_at_loc))
					{
						var tileString:String = leveldata.tilesDictionary[str_at_loc];
						if (tileString == "black")
						{
							room.SetBlackTile(i, j);
						}
						else
						{
							room.SetTile(LevelTile.CreateTile(tileString), i, j);
						}
					}
				}
			}
			
			level.rooms.push(room);
		}
		
		for (rmname in leveldata.roomDoorsDictionary)
		{
			for (drname in leveldata.roomDoorsDictionary[rmname])
			{
				if (leveldata.roomDoorsDictionary[rmname][drname] != null)
				{
					var firstDoorInfo = leveldata.roomDoorsDictionary[rmname][drname].split(",");
					
					if (firstDoorInfo.length != 4) continue;
					
					var firstRoomIndex = roomKeyArray.indexOf(rmname);
					var firstDoorId = drname;
					var firstDoorTileX = doorLocations[rmname][drname][0];
					var firstDoorTileY = doorLocations[rmname][drname][1];
					var secondDoorId = firstDoorInfo[1];
					var secondRoomIndex = roomKeyArray.indexOf(firstDoorInfo[0]);
					var secondDoorTileX = doorLocations[firstDoorInfo[0]][secondDoorId][0];
					var secondDoorTileY = doorLocations[firstDoorInfo[0]][secondDoorId][1];
					var firstDoorOrientation = firstDoorInfo[2];
					var doorWidth = Std.parseInt(firstDoorInfo[3]);
					level.CreateDoor(firstRoomIndex, firstDoorId, firstDoorTileX, firstDoorTileY, secondDoorId, secondRoomIndex, secondDoorTileX, secondDoorTileY, firstDoorOrientation, doorWidth);
				}
			}
		}
		
		level.currentRoom = level.rooms[0];
		level.addChild(level.currentRoom);
		
		level.AddBg();
		
		level.currentRoom.AddBgFg();
		
		//level.currentRoom.AddTriangle(123, 513, 54, 234, 312, 155);
		
		return level;
	}
	
	var leveldata2:LevelData2;
	
	public function OutputJSON()
	{
		var result:String = "";
		
		result = Json.stringify(leveldata2);
		
		return result;
	}
	
	public function ConvertToJSON()
	{
		leveldata2 = {
			tileDef : new Array<String>(),
			rooms : new Array<LevelRoomData>()
		};
		
		for (tiledat in leveldata.tilesDictionary)
		{
			leveldata2.tileDef.push(leveldata.tilesDictionary[tiledat]);
		}
		
		for (room in leveldata.roomsDictionary)
		{
			var room2:LevelRoomData = {
				tileMap : new Array<Array<Int>>(),
				entities : new Array<EntityData>(),
				doors : new Array<DoorData>()
			};
			
			for (i in 0...leveldata.roomsDictionary[room].length)
			{
				var newrow:Array<Int> = new Array<Int>();
				for (j in 0...leveldata.roomsDictionary[room][0].length)
				{
					switch leveldata.roomsDictionary[room][i][j]
					{
					  case " ":
						newrow.push(0);
					  case "p":
						var entdata:EntityData = {
							x : (j * LevelTile.size) + (LevelTile.size / 2),
							y : (i * LevelTile.size) + (LevelTile.size / 2),
							data : "PlayerSpawn"
						};
						newrow.push(0);
						room2.entities.push(entdata);
					  case "e":
						var entdata:EntityData = {
							x : (j * LevelTile.size) + (LevelTile.size / 2),
							y : (i * LevelTile.size) + (LevelTile.size / 2),
							data : "Enemy1"
						};
						room2.entities.push(entdata);
						newrow.push(0);
					  case "a":
						newrow.push(2);
					  case "b":
						newrow.push(2);
					  case "c":
						newrow.push(2);
					  case "d":
						newrow.push(2);
					  case "q":
						newrow.push(2);
					  default:
						newrow.push(1 + Std.parseInt(leveldata.roomsDictionary[room][i][j]));
					}
				}
				room2.tileMap.push(newrow);
			}
			
			leveldata2.rooms.push(room2);
		}
		
		for (room in leveldata.roomDoorsDictionary.iterator())
		{
			for (door in leveldata.roomDoorsDictionary[room].iterator())
			{
				var xtile:Int = 0;
				var ytile:Int = 0;
				
				for (i in 0...leveldata.roomsDictionary[room].length)
				{
					for (j in 0...leveldata.roomsDictionary[room][i].length)
					{
						if (leveldata.roomsDictionary[room][i][j] == door)
						{
							xtile = j;
							ytile = i;
						}
					}
				}
				
				var newdoordata = "";
				
				var splitdoordata = leveldata.roomDoorsDictionary[room][door].split(",");
				
				if (splitdoordata.length == 4)
				{
					switch splitdoordata[1]
					{
						case "a": splitdoordata[1]=0 + "";
						case "b": splitdoordata[1]=1 + "";
						case "c": splitdoordata[1]=2 + "";
						case "d": splitdoordata[1]=3 + "";
						case "q": splitdoordata[1]=0 + "";
					}
					
					newdoordata = splitdoordata[0]+","+splitdoordata[1]+","+splitdoordata[2]+","+splitdoordata[3];
				}
				
				var newdoor:DoorData = { x : xtile, y : ytile, data : newdoordata };
				leveldata2.rooms[Std.parseInt(room) - 1].doors.push(newdoor);
			}
		}
	}
	
	public function BuildLevel2(bg:Sprite, fg:Sprite):Level
	{
		var level2:Level = new Level(bg, fg);
		
		for (roomdata in leveldata2.rooms)
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
						var tiledata = leveldata2.tileDef[tileindex];
						
						if (tiledata == "Black")
						{
							room.SetBlackTile(i, j);
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
					level2.currentRoom = room;
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
			level2.rooms.push(room);
		}
		
		for (roomindex in 0...leveldata2.rooms.length)
		{
			var roomdata = leveldata2.rooms[roomindex];
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
				var secondDoorTileX = leveldata2.rooms[secondRoomIndex].doors[secondDoorId].x;
				var secondDoorTileY = leveldata2.rooms[secondRoomIndex].doors[secondDoorId].y;
				var firstDoorOrientation = firstDoorInfo[2];
				var doorWidth = Std.parseInt(firstDoorInfo[3]);
				level2.CreateDoor(firstRoomIndex, firstDoorId + "", firstDoorTileX, firstDoorTileY, secondDoorId + "", secondRoomIndex, secondDoorTileX, secondDoorTileY, firstDoorOrientation, doorWidth);
			}
		}
		
		level2.addChild(level2.currentRoom);
		return level2;
	}
}

typedef LevelData = 
{
	var tilesDictionary:Dictionary<String,String>;
	var entitiesDictionary:Dictionary<String,String>;
	var roomsDictionary:Dictionary<String,Array<Array<String>>>;
	var roomDoorsDictionary:Dictionary<String,Dictionary<String,String>>;
}

typedef LevelData2 =
{
	var tileDef:Array<String>;
	var rooms:Array<LevelRoomData>;
}

typedef LevelRoomData =
{
	var tileMap:Array<Array<Int>>;
	var entities:Array<EntityData>;
	var doors:Array<DoorData>;
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