package world.tiles;

/**
 * ...
 * @author ...
 */
class HDoorTile extends DoorTile
{
	public function new(size:Float) 
	{
		super(size);
		UsePic("img/testdoor.bmp");
		
		hitShape.AddPoint( -tileSize / 2, -tileSize / 4);
		hitShape.AddPoint( tileSize / 2, -tileSize / 4);
		hitShape.AddPoint( tileSize / 2, tileSize / 4);
		hitShape.AddPoint( -tileSize / 2, tileSize / 4);
		
		isVertical = false;
	}
}