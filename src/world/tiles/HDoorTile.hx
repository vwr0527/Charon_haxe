package world.tiles;
import world.LevelTile;

/**
 * ...
 * @author ...
 */
class HDoorTile extends LevelTile
{
	public function new(size:Float) 
	{
		super(size);
		UsePic("img/testdoor.bmp");
		
		hitShape.AddPoint( -tileSize / 2, -tileSize / 4);
		hitShape.AddPoint( tileSize / 2, -tileSize / 4);
		hitShape.AddPoint( tileSize / 2, tileSize / 4);
		hitShape.AddPoint( -tileSize / 2, tileSize / 4);
	}
}