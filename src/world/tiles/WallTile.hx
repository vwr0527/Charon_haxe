package world.tiles;
import world.LevelTile;

/**
 * ...
 * @author 
 */
class WallTile extends LevelTile
{

	public function new(size:Float) 
	{
		super(size);
		UsePic("img/testtile.bmp");
		
		hitShape.MakeSquare(tileSize);
	}
}