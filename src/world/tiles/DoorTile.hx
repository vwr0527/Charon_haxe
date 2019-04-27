package world.tiles;
import world.LevelTile;

/**
 * ...
 * @author ...
 */
class DoorTile extends LevelTile
{
	var isOpen:Bool = false;
	var isVertical:Bool;
	var identifier:String;
	
	public function new(orientation:Bool, id:String) 
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
			sprite.alpha = 0.2;
		}
		else
		{
			sprite.alpha = 1.0;
		}
	}
	
	public function GetID():String
	{
		return identifier;
	}
}