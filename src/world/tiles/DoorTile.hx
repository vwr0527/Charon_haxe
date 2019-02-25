package world.tiles;
import world.LevelTile;

/**
 * ...
 * @author ...
 */
class DoorTile extends LevelTile
{
	public function new(size:Float) 
	{
		super(size);
		UsePic("img/testdoor.bmp");
		
		hitShape.MakeSquare(tileSize);
	}
}