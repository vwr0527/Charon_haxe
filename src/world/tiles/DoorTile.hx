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
	var identifier:Int;
	var openTime = 0;
	
	public function new(size:Float, orientation:Bool, id:Int) 
	{
		super(size);
		isVertical = orientation;
		identifier = id;
	}
	
	public override function Update()
	{
		if (isOpen) openTime ++;
		
		if (openTime > 300)
		{
			SetOpen(false);
		}
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
			openTime = 0;
		}
		else
		{
			sprite.alpha = 1.0;
		}
	}
}