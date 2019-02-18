package world.levels;
import world.LevelRoom;
import world.LevelTile;

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
				var newtile = new LevelTile(room1.tsize);
				if (j == 0 || j == room1.xtiles - 1 || i == 0 || i == room1.ytiles - 1) newtile.InitTest();
				newRow.push(newtile);
				room1.addChild(newtile);
				newtile.x = (j * room1.tsize) + room1.tstartx + room1.tsize / 2;
				newtile.y = (i * room1.tsize) + room1.tstarty + room1.tsize / 2;
			}
		}
		
		room1.tiles[15][28].InitBRTest();
		room1.tiles[15][1].InitBLTest();
		room1.tiles[1][1].InitTLTest();
		room1.tiles[1][28].InitTRTest();
		
		level.rooms.push(room1);
		level.currentRoom = room1;
		level.addChild(room1);
	}
}