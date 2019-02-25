package world.tiles;

/**
 * ...
 * @author 
 */
class BLWallTile extends LevelTile
{

	public function new(size:Float) 
	{
		super(size);
		UsePic("img/testdiagtile.bmp");
		sprite.rotation = 270;
		
		hitShape.AddPoint( -tileSize / 2, -tileSize / 2);
		hitShape.AddPoint( tileSize / 2, tileSize / 2);
		hitShape.AddPoint( -tileSize / 2, tileSize / 2);
	}
	
}