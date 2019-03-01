package world.tiles;
import world.LevelTile;

/**
 * ...
 * @author ...
 */
class VDoorTile extends DoorTile
{
	public function new(size:Float) 
	{
		super(size);
		UsePic("img/testdoor.bmp");
		sprite.rotation = 90;
		
		hitShape.AddPoint( -tileSize / 4, -tileSize / 2);
		hitShape.AddPoint( tileSize / 4, -tileSize / 2);
		hitShape.AddPoint( tileSize / 4, tileSize / 2);
		hitShape.AddPoint( -tileSize / 4, tileSize / 2);
	}
}