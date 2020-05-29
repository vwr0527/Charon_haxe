package;

import openfl.ui.Mouse;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.net.SharedObject;

/**
 * ...
 * @author Victor Reynolds
 */
class Main extends Sprite 
{
	var world:World;
	var menu:Menu;
	var input:Input;
	var storage:SharedObject;
	
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
		
		/*
		storage = SharedObject.getLocal("myStorageTest");
		storage.data.testThing = "Hello this is a persistent storage test.";
		storage.flush;
		
		for (thing in Reflect.fields(storage.data))
		{
			trace(thing);
		}
		
		Reflect.deleteField(storage.data, "testThing");
		trace (storage.data.testThing);
		*/
		
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
		
		Mouse.hide();
	}
	
	public function Update(e)
	{
		++count;
		
		if (calculatingFPS) return;
		
		if (!menu.isActive)
		{
			Mouse.hide();
			world.Update();
		}
		else
		{
			Mouse.show();
		}
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