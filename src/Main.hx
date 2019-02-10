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
	
	var calcFpsTimer:Timer;
	var frameTimer:Timer;
	var calculatingFPS:Bool = true;
	var count = 0;
	var prevcount = 0;
	
	static var EnterFrameMode = true;
	static var TargetFPS = 60;
	
	static var FrameModeChange = false;
	static var fps = 0;
	
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
		
		calcFpsTimer = new Timer(1000);
		calcFpsTimer.addEventListener(TimerEvent.TIMER, CalcFPS);
		calcFpsTimer.start();
		
		frameTimer = new Timer(1000/TargetFPS);
		frameTimer.addEventListener(TimerEvent.TIMER, Update);
		if (!EnterFrameMode) frameTimer.start();
	}
	
	public function Update(e)
	{
		++count;
		
		if (calculatingFPS) return;
		
		if (!menu.isActive()) world.Update();
		menu.Update();
		input.Update();
	}
	
	public function LostFocus(e)
	{
		calcFpsTimer.stop();
	}
	
	public function RegainedFocus(e)
	{
		calcFpsTimer.reset();
		calcFpsTimer.start();
		
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
				frameTimer.stop();
				addEventListener(Event.ENTER_FRAME, Update);
			}
			else
			{
				frameTimer.start();
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