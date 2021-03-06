package world.level.tiles;
import world.level.LevelTile;

/**
 * ...
 * @author 
 */
class BRWallTile extends LevelTile
{

	public function new() 
	{
		super();
		UsePic("img/testdiagtile.bmp", 180);
		
		var size = LevelTile.size;
		
		hitShape.AddPoint( size / 2, -size / 2);
		hitShape.AddPoint( size / 2, size / 2);
		hitShape.AddPoint( -size / 2, size / 2);
	}
	
}