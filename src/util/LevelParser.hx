package util;
import openfl.Assets;
import openfl.utils.Dictionary;
import world.Enemy;
import world.Level;
import world.LevelRoom;
import world.LevelTile;

/**
 * ...
 * @author 
 */
class LevelParser 
{
	public static function LoadLevel(levelname:String):Level
	{
		var leveltext = Assets.getText(levelname).split("\n");
		leveltext.push("");
		var tilesDictionary:Dictionary<String,String> = new Dictionary<String,String>();
		var entitiesDictionary:Dictionary<String,String> = new Dictionary<String,String>();
		var roomsDictionary:Dictionary<String,Array<Array<String>>> = new Dictionary<String,Array<Array<String>>>();
		var roomDoorsDictionary:Dictionary<String,Dictionary<String,String>> = new Dictionary<String,Dictionary<String,String>>();
		var currentDoorsDictionary:Dictionary<String,String> = new Dictionary<String,String>();
		var currentSection:String = "none";
		var currentRoom:String = "none";
		var currentRoomContent:Array<Array<String>> = new Array<Array<String>>();
		var startedReadingCurrentRoom:Bool = false;
		var finishedReadingCurrentRoom:Bool = false;
		var startedReadingCurrentRoomDoors:Bool = false;
		var finishedReadingCurrentRoomDoors:Bool = false;
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
				tilesDictionary.set(splitLine[0], splitLine[1]);
				
				continue;
			}
			if (currentSection == "Entities")
			{
				if (line.indexOf(": ") == -1) continue;
				
				var splitLine = line.split(": ");
				entitiesDictionary.set(splitLine[0], splitLine[1]);
				
				continue;
			}
			if (currentSection == "Room")
			{
				if (finishedReadingCurrentRoom) continue;
				if (line.indexOf(",") == -1 && !startedReadingCurrentRoom) continue;
				if (line.indexOf(",") == -1 && startedReadingCurrentRoom)
				{
					roomsDictionary.set(currentRoom, currentRoomContent);
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
					roomDoorsDictionary.set(currentRoom, currentDoorsDictionary);
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
		
		var level:Level = new Level();
		
		var roomKeyArray:Array<String> = new Array<String>();
		var doorLocations:Dictionary<String,Dictionary<String,Array<Int>>> = new Dictionary<String,Dictionary<String,Array<Int>>>(); // roomname, doorname, x, y
		
		for (roomKey in roomsDictionary)
		{
			roomKeyArray.push(roomKey);
			var num_x_tiles:Int = roomsDictionary[roomKey][0].length;
			var num_y_tiles:Int = roomsDictionary[roomKey].length;
			
			var room:LevelRoom = new LevelRoom(num_x_tiles, num_y_tiles);
			
			for (j in 0...num_y_tiles)
			{
				for (i in 0...num_x_tiles)
				{
					var str_at_loc:String = roomsDictionary[roomKey][j][i];
					
					if (entitiesDictionary.exists(str_at_loc))
					{
						if (entitiesDictionary[str_at_loc] == "PlayerSpawn")
						{
							room.playerSpawnX = (i * LevelTile.size) + (LevelTile.size / 2);
							room.playerSpawnY = (j * LevelTile.size) + (LevelTile.size / 2);
						}
						else if (entitiesDictionary[str_at_loc] == "Enemy1")
						{
							var enemy:Enemy = new Enemy();
							enemy.x = (i * LevelTile.size) + (LevelTile.size / 2);
							enemy.y = (j * LevelTile.size) + (LevelTile.size / 2);
							enemy.age = Std.int(Math.random() * 1000);
							room.ents.push(enemy);
						}
					}
					else if (roomDoorsDictionary[roomKey].exists(str_at_loc))
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
					else if (tilesDictionary.exists(str_at_loc))
					{
						var tileString:String = tilesDictionary[str_at_loc];
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
		
		for (rmname in roomDoorsDictionary)
		{
			for (drname in roomDoorsDictionary[rmname])
			{
				if (roomDoorsDictionary[rmname][drname] != null)
				{
					var firstDoorInfo = roomDoorsDictionary[rmname][drname].split(",");
					
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
		level.currentRoom.AddPic();
		
		return level;
	}
}