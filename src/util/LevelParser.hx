package util;
import openfl.Assets;
import openfl.utils.Dictionary;
import world.Level;

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
					var splitLine = line.split(": ");
					currentDoorsDictionary.set(splitLine[0],splitLine[1]);
				}
				
				continue;
			}
		}
		/* verification
		trace(tilesDictionary);
		trace(entitiesDictionary);
		for (r in roomsDictionary)
		{
			trace (r);
			for (sa in roomsDictionary[r])
			{
				trace (sa);
			}
		}
		for (rn in roomDoorsDictionary)
		{
			trace (rn);
			trace (roomDoorsDictionary[rn]);
		}
		*/
		
		return new Level();
	}
}