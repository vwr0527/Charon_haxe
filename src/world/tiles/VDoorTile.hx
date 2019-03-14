package world.tiles;

/**
 * ...
 * @author ...
 */
class VDoorTile extends DoorTile
{
	public function new(size:Float, id:Int) 
	{
		super(size, true, id);
		UsePic("img/testdoor.bmp");
		sprite.rotation = 90;
		
		hitShape.AddPoint( -tileSize / 4, -tileSize / 2);
		hitShape.AddPoint( tileSize / 4, -tileSize / 2);
		hitShape.AddPoint( tileSize / 4, tileSize / 2);
		hitShape.AddPoint( -tileSize / 4, tileSize / 2);
	}
}