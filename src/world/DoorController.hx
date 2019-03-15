package world;
import world.tiles.DoorTile;

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
	
	public function new() 
	{
		doorTiles = new Array();
	}
	
	public function Update()
	{
		if (isOpen) openTime ++;
		
		if (openTime > 100)
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