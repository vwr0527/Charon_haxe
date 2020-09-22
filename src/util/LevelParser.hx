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
	var leveltext:String;
	var level:Level;
	var leveldata:LevelData;
	
	public function new()
	{
		leveldata =  {
			tileDef : new Array<String>(),
			rooms : new Array<LevelRoomData>()
		};
	}
		
	public function ReadLevel(levelname:String)
	{
		leveltext = Assets.getText(levelname);
		leveldata = Json.parse(leveltext);
	}
	
	public function BuildLevel(bg:Sprite, fg:Sprite):Level
	{
		var level:Level = new Level(bg, fg);
		
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
						
						if (tiledata == "Black")
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
		return level;
	}
}

typedef LevelData =
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