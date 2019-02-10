package world;
import openfl.display.Sprite;
import world.LevelRoom;

/**
 * ...
 * @author Victor Reynolds
 */
class Level extends Sprite
{
	public var rooms:Array<LevelRoom>;
	var currentRoom:LevelRoom;

	public function new() 
	{
		super();
		rooms = new Array();
		rooms.push(new LevelRoom());
		currentRoom = rooms[0];
		addChild(currentRoom);
	}
	
	public function StartRoom():LevelRoom
	{
		return rooms[0];
	}
	
	public function CurrentRoom():LevelRoom
	{
		return currentRoom;
	}
}