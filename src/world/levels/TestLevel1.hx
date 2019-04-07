package world.levels;
import world.LevelRoom;
import world.tiles.*;

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
		var room = new LevelRoom(-480, 480, -270, 270, 32, 30, 17, -480, -270);
		
		for (i in 0...17)
		{
			for (j in 0...30)
			{
				if (j == 0 || j == 29 || i == 0 || i == 16)
				{
					if (i == 16 && (j >= 13 && j <= 16))
						room.SetDoor(new HDoorTile(32, 0), j, i);
					else if (j == 29 && (i >= 6 && i <= 9))
						room.SetDoor(new VDoorTile(32, 1), j, i);
					else
						room.SetTile(new WallTile(32), j, i);
				}
			}
		}
		
		room.SetTile(new BRWallTile(32), 28, 15);
		room.SetTile(new BLWallTile(32), 1, 15);
		room.SetTile(new TLWallTile(32), 1, 1);
		room.SetTile(new TRWallTile(32), 28, 1);
		room.doors[0].targetDoor = 0;
		room.doors[0].targetRoom = 1;
		room.doors[0].enterDirX = 0;
		room.doors[0].enterDirY = -1;
		room.doors[1].targetDoor = 0;
		room.doors[1].targetRoom = 1;
		room.doors[1].enterDirX = -1;
		room.doors[1].enterDirY = 0;
		
		level.rooms.push(room);
		level.currentRoom = room;
		level.addChild(room);
		
		var room2 = new LevelRoom(-480, 480, -270, 270, 32, 30, 17, -480, -270);
		
		for (i in 0...17)
		{
			for (j in 0...30)
			{
				if (j == 0 || j == 29 || i == 0 || i == 16)
				{
					if (i == 0 && (j >= 13 && j <= 16))
						room2.SetDoor(new HDoorTile(32, 0), j, i);
					else
						room2.SetTile(new WallTile(32), j, i);
				}
			}
		}
		
		room2.SetTile(new BRWallTile(32), 13, 7);
		room2.SetTile(new BLWallTile(32), 14, 7);
		room2.SetTile(new TLWallTile(32), 14, 8);
		room2.SetTile(new TRWallTile(32), 13, 8);
		room2.doors[0].targetDoor = 0;
		room2.doors[0].targetRoom = 0;
		room2.doors[0].enterDirX = 0;
		room2.doors[0].enterDirY = 1;
		
		level.rooms.push(room2);
	}
}