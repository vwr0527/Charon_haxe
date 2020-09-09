package world.level.tiles;
import world.level.LevelTile;

/**
 * ...
 * @author ...
 */
class HDoorTile extends DoorTile
{
	public function new(id:String) 
	{
		super(false, id);
		UsePic("img/testdoor.bmp");
		
		var size = LevelTile.size;
		
		hitShape.AddPoint( -size / 2, -size / 4);
		hitShape.AddPoint( size / 2, -size / 4);
		hitShape.AddPoint( size / 2, size / 4);
		hitShape.AddPoint( -size / 2, size / 4);
	}
}