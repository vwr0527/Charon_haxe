package world.tiles;
import world.LevelTile;

/**
 * ...
 * @author 
 */
class WallTile extends LevelTile
{

	public function new() 
	{
		super();
		UsePic("img/testtile.bmp");
		
		var size = LevelTile.size;
		
		hitShape.MakeSquare(size);
	}
}