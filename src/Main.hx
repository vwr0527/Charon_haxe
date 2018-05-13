package;

import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Victor Reynolds
 */
class Main extends Sprite 
{
	private var world:World;
	private var menu:Menu;
	private var input:Input;
	
	public function new() 
	{
		super();
		
		menu = new Menu();
		world = new World();
		input = new Input();
		addChild(world);
		addChild(menu);
		addChild(input);
		
		addEventListener(Event.ENTER_FRAME, Update);
	}
	
	public function Update(e)
	{
		menu.Update();
		world.Update();
		input.Update();
	}
}