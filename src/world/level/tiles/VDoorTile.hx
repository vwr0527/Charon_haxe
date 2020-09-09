package world.level.tiles;
import world.level.LevelTile;

/**
 * ...
 * @author ...
 */
class VDoorTile extends DoorTile
{
	public function new(id:String) 
	{
		super(true, id);
		UsePic("img/testdoor.bmp", 90);
		
		var size = LevelTile.size;
		
		hitShape.AddPoint( -size / 4, -size / 2);
		hitShape.AddPoint( size / 4, -size / 2);
		hitShape.AddPoint( size / 4, size / 2);
		hitShape.AddPoint( -size / 4, size / 2);
	}
}