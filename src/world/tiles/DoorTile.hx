package world.tiles;
import world.LevelTile;

/**
 * ...
 * @author ...
 */
class DoorTile extends LevelTile
{
	var isOpen:Bool = false;
	public var thisDoorNumber:Int;
	public var targetDoorNumber:Int;
	public var roomIndex:Int;
	public var isVertical:Bool;
	
	public function new(size:Float) 
	{
		super(size);
		
		SetOpen(true);//temp
	}
	
	public function IsOpen():Bool
	{
		return isOpen;
	}
	
	public function SetOpen(open:Bool)
	{
		isOpen = open;
		noclip = open;
	}
}