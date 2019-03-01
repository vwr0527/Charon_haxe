package world.tiles;
import world.LevelTile;

/**
 * ...
 * @author ...
 */
class DoorTile extends LevelTile
{
	var isOpen:Bool = true;
	
	public function new(size:Float) 
	{
		super(size);
	}
	
	public function IsOpen():Bool
	{
		return isOpen;
	}
}