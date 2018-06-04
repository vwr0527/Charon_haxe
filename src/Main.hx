package;

import openfl.display.Sprite;
import openfl.events.Event;
import haxe.Timer;

/**
 * ...
 * @author Victor Reynolds
 */
class Main extends Sprite 
{
	var world:World;
	var menu:Menu;
	var input:Input;
	var timer:Timer;
	var calculatingFPS:Bool = true;
	var count = 0;
	var prevcount = 0;
	
	static var fps = 0;
	public static var RecycleMode = false;
	
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
		addEventListener(Event.DEACTIVATE, LostFocus);
		addEventListener(Event.ACTIVATE, RegainedFocus);
		
		timer = new Timer(1000);
		timer.run = CalcFPS;
	}
	
	public function Update(e)
	{
		++count;
		
		if (calculatingFPS) return;
		
		menu.Update();
		world.Update();
		input.Update();
	}
	
	public function LostFocus(e)
	{
		timer.stop();
	}
	
	public function RegainedFocus(e)
	{
		timer = new Timer(1000);
		timer.run = CalcFPS;
		
		calculatingFPS = true;
		count = 0;
		prevcount = 0;
		fps = 0;
	}
	
	public function CalcFPS()
	{
		fps = count - prevcount;
		prevcount = count;
		calculatingFPS = false;
	}
	
	public static function getFPS():Float
	{
		return fps;
	}
}