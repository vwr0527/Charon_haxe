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
	public var room1:LevelRoom;
	public function new() 
	{
		level = new Level();
		room1 = new LevelRoom();
		
		room1.xmin = -480;
		room1.xmax = 480;
		room1.ymin = -270;
		room1.ymax = 270;
		room1.tsize = 32;
		room1.xtiles = 30;
		room1.ytiles = 17;
		room1.tstartx = -480;
		room1.tstarty = -270;
		
		for (i in 0...room1.ytiles)
		{
			var newRow = new Array();
			room1.tiles.push(newRow);
			for (j in 0...room1.xtiles)
			{
				var newtile:LevelTile;
				if (i == 16 && (j >= 13 && j <= 15))
					newtile = new DoorTile(room1.tsize);
				else
					newtile = new LevelTile(room1.tsize);
					
				if (j == 0 || j == room1.xtiles - 1 || i == 0 || i == room1.ytiles - 1) newtile.Init();
				newRow.push(newtile);
				room1.addChild(newtile);
				newtile.x = (j * room1.tsize) + room1.tstartx + room1.tsize / 2;
				newtile.y = (i * room1.tsize) + room1.tstarty + room1.tsize / 2;
			}
		}
		
		room1.tiles[15][28].InitBR();
		room1.tiles[15][1].InitBL();
		room1.tiles[1][1].InitTL();
		room1.tiles[1][28].InitTR();
		
		level.rooms.push(room1);
		level.currentRoom = room1;
		level.addChild(room1);
	}
}