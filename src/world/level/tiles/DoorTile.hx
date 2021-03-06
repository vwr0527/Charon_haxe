package world.level.tiles;
import world.level.LevelTile;

/**
 * ...
 * @author ...
 */
class DoorTile extends LevelTile
{
	var isOpen:Bool = false;
	var isVertical:Bool;
	var identifier:Int;
	
	public function new(orientation:Bool, id:Int) 
	{
		super();
		isVertical = orientation;
		identifier = id;
	}
	
	public override function Update()
	{
	}
	
	public function IsOpen():Bool
	{
		return isOpen;
	}
	
	public function IsVertical():Bool
	{
		return isVertical;
	}
	
	public function SetOpen(open:Bool)
	{
		isOpen = open;
		noclip = open;
		if (open)
		{
			alpha = 0.2;
		}
		else
		{
			alpha = 1.0;
		}
	}
	
	public function GetID():Int
	{
		return identifier;
	}
}