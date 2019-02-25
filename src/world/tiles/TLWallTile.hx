package world.tiles;

/**
 * ...
 * @author 
 */
class TLWallTile extends LevelTile
{

	public function new(size:Float) 
	{
		super(size);
		UsePic("img/testdiagtile.bmp");
		
		hitShape.AddPoint( -tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( -tileSize / 2, tileSize / 2);
	}
	
}