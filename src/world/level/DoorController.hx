package world.level;
import world.level.tiles.DoorTile;

/**
 * ...
 * @author 
 */
class DoorController 
{
	public var doorTiles:Array<DoorTile>;
	public var targetRoom:Int;
	public var targetDoor:Int;
	public var openTime:Int;
	public var isOpen:Bool = false;
	public var enterDirX:Float = 0;
	public var enterDirY:Float = 0;
	
	public function new() 
	{
		doorTiles = new Array();
	}
	
	public function Update()
	{
		if (isOpen) openTime ++;
		
		if (openTime > 100 && isOpen)
		{
			SetOpen(false);
		}
	}
	
	public function SetOpen(open:Bool)
	{
		isOpen = open;
		for (i in 0...doorTiles.length)
		{
			doorTiles[i].SetOpen(open);
		}
		if (open)
		{
			openTime = 0;
		}
	}
}