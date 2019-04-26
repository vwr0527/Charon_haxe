package world.levels;
import openfl.Assets;
import world.Enemy;
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
		var lvldata = Assets.getText("levels/testlevel1.txt").split(",");
		var room1parms:Array<Int> = new Array<Int>();
		for (s in lvldata)
		{
			room1parms.push(Std.parseInt(s));
		}
		trace(room1parms);
		
		level = new Level();
		var room = new LevelRoom(30, 17);
		
		for (i in 0...17)
		{
			for (j in 0...30)
			{
				if (j == 0 || j == 29 || i == 0 || i == 16)
				{
					room.SetTile(LevelTile.CreateTile("W,img/testtile.bmp"), j, i);
				}
			}
		}
		
		room.SetTile(LevelTile.CreateTile("BR,img/testdiagtile.bmp"), 28, 15);
		room.SetTile(LevelTile.CreateTile("BL,img/testdiagtile.bmp"), 1, 15);
		room.SetTile(LevelTile.CreateTile("TL,img/testdiagtile.bmp"), 1, 1);
		room.SetTile(LevelTile.CreateTile("TR,img/testdiagtile.bmp"), 28, 1);
		
		room.playerSpawnX = 480;
		room.playerSpawnY = 270;
		
		room.ents.push(new Enemy());
		room.ents[0].x = 480;
		room.ents[0].y = 270;
		
		level.rooms.push(room);
		level.currentRoom = room;
		level.addChild(room);
		
		var room2 = new LevelRoom(30, 17);
		
		for (i in 0...17)
		{
			for (j in 0...30)
			{
				if (j == 0 || j == 29 || i == 0 || i == 16)
				{
					room2.SetTile(new WallTile(), j, i);
				}
			}
		}
		
		room2.SetTile(new BRWallTile(), 13, 7);
		room2.SetTile(new BLWallTile(), 14, 7);
		room2.SetTile(new TLWallTile(), 14, 8);
		room2.SetTile(new TRWallTile(), 13, 8);
		
		room2.ents.push(new Enemy());
		room2.ents[0].x = 480 + 40;
		room2.ents[0].y = 270;
		var enemy2 = new Enemy();
		enemy2.x = 480;
		enemy2.y = 270 + 50;
		enemy2.age = 75;
		room2.ents.push(enemy2);
		
		level.rooms.push(room2);
		
		var room3 = new LevelRoom(17, 17);
		
		for (i in 0...17)
		{
			for (j in 0...17)
			{
				if (j == 0 || j == 16 || i == 0 || i == 16)
				{
					room3.SetTile(new WallTile(), j, i);
				}
			}
		}
		
		level.rooms.push(room3);
		
		level.CreateDoor(0, 0, 13, 16, 0, 1, 13, 0, 1, 4);
		level.CreateDoor(0, 1, 29, 7, 0, 2, 0, 10, 0, 4);
	}
}