package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

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
	var timer2:Timer;
	var calculatingFPS:Bool = true;
	var count = 0;
	var prevcount = 0;
	
	static var fps = 0;
	public static var RecycleMode = false;
	public static var EnterFrameMode = false;
	public static var FrameModeChange = false;
	
	public function new() 
	{
		super();
		
		menu = new Menu();
		world = new World();
		input = new Input();
		addChild(world);
		addChild(menu);
		addChild(input);
		
		if (EnterFrameMode) addEventListener(Event.ENTER_FRAME, Update);
		addEventListener(Event.DEACTIVATE, LostFocus);
		addEventListener(Event.ACTIVATE, RegainedFocus);
		
		timer = new Timer(1000);
		timer.addEventListener(TimerEvent.TIMER, CalcFPS);
		timer.start();
		
		timer2 = new Timer(16);
		timer2.addEventListener(TimerEvent.TIMER, Update);
		if (!EnterFrameMode) timer2.start();
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
		timer.reset();
		timer.start();
		
		calculatingFPS = true;
		count = 0;
		prevcount = 0;
		fps = 0;
	}
	
	public function CalcFPS(e)
	{	
		fps = count - prevcount;
		prevcount = count;
		calculatingFPS = false;
		
		if (FrameModeChange)
		{
			if (EnterFrameMode == true)
			{
				timer2.stop();
				addEventListener(Event.ENTER_FRAME, Update);
			}
			else
			{
				timer2.start();
				removeEventListener(Event.ENTER_FRAME, Update);
			}
			FrameModeChange = false;
		}
	}
	
	public static function ChangeFrameMode(setEnterFrameMode)
	{
		if (EnterFrameMode != setEnterFrameMode)
		{
			FrameModeChange = true;
		}
	}
	
	public static function getFPS():Float
	{
		return fps;
	}
}