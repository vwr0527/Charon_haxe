package world.tiles;

/**
 * ...
 * @author ...
 */
class HDoorTile extends DoorTile
{
	public function new(size:Float, id:Int) 
	{
		super(size, false, id);
		UsePic("img/testdoor.bmp");
		
		hitShape.AddPoint( -tileSize / 2, -tileSize / 4);
		hitShape.AddPoint( tileSize / 2, -tileSize / 4);
		hitShape.AddPoint( tileSize / 2, tileSize / 4);
		hitShape.AddPoint( -tileSize / 2, tileSize / 4);
	}
}