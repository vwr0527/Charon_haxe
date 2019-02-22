package world.levels;
import world.LevelRoom;
import world.LevelTile;
import world.tiles.DoorTile;

/**
 * ...
 * @author 
 */
class TestLevel1 
{
	public var level:Level;
	public function new() 
	{
		level = new Level();
		var room = new LevelRoom();
		
		room.xmin = -480;
		room.xmax = 480;
		room.ymin = -270;
		room.ymax = 270;
		room.tsize = 32;
		room.xtiles = 30;
		room.ytiles = 17;
		room.tstartx = -480;
		room.tstarty = -270;
		
		for (i in 0...room.ytiles)
		{
			var newRow = new Array();
			room.tiles.push(newRow);
			for (j in 0...room.xtiles)
			{
				var newtile:LevelTile;
				if (i == 16 && (j >= 13 && j <= 16))
					newtile = new DoorTile(room.tsize);
				else
					newtile = new LevelTile(room.tsize);
					
				if (j == 0 || j == room.xtiles - 1 || i == 0 || i == room.ytiles - 1) newtile.Init();
				newRow.push(newtile);
				room.addChild(newtile);
				newtile.x = (j * room.tsize) + room.tstartx + room.tsize / 2;
				newtile.y = (i * room.tsize) + room.tstarty + room.tsize / 2;
			}
		}
		
		room.tiles[15][28].InitBR();
		room.tiles[15][1].InitBL();
		room.tiles[1][1].InitTL();
		room.tiles[1][28].InitTR();
		
		level.rooms.push(room);
		level.currentRoom = room;
		level.addChild(room);
	}
}