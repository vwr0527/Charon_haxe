package;

import openfl.ui.Mouse;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.net.SharedObject;
import openfl.Lib;
import util.LevelEditor;

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
	
	var updateTimer:Timer;
	var stopped:Bool = false;
	
	static var EnterFrameMode = true;
	static var TargetFPS = 60;
	
	static var FrameModeChange = false;
	static public var fps = 60.0;
	static public var prevFPS:Array<Float>;
	static var pfpsc:Int;
	
	static var time:Int;
	static var currenttime:Int;
	static var elapsed:Int;
	
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
		
		updateTimer = new Timer(1000/TargetFPS);
		updateTimer.addEventListener(TimerEvent.TIMER, Update);
		if (!EnterFrameMode) updateTimer.start();
		else updateTimer.stop();
		
		Mouse.hide();
		time = 0;
		prevFPS = new Array<Float>();
		for (i in 0...60)
		{
			prevFPS.push(1);
		}
		pfpsc = 0;
		time = Lib.getTimer();
	}
	
	public function Update(e)
	{
		currenttime = Lib.getTimer();
		elapsed = currenttime - time;
		time = currenttime;
		prevFPS[pfpsc] = (elapsed * 1.0);
		pfpsc += 1;
		if (pfpsc >= 60) pfpsc = 0;
		fps = 0;
		
		for (i in 0...60)
		{
			fps += prevFPS[i];
		}
		fps = 1000 / (fps / 60);
		
		if (EnterFrameMode == false)
		{
			if (fps > TargetFPS)
			{
				updateTimer.delay = (1000 / TargetFPS);
			}
			else if (fps < TargetFPS - 1)
			{
				updateTimer.delay = (1000 / TargetFPS) - 2;
			}
			else if (fps < TargetFPS - 0.5)
			{
				updateTimer.delay = (1000 / TargetFPS) - 1;
			}
		}
		
		//fps = 1000.0 / ((Lib.getTimer() - time) * 1.0);
		//time = Lib.getTimer();
		
		if (stopped) return;
		
		if (FrameModeChange)
		{
			if (EnterFrameMode == true)
			{
				updateTimer.stop();
				addEventListener(Event.ENTER_FRAME, Update);
			}
			else
			{
				updateTimer.start();
				removeEventListener(Event.ENTER_FRAME, Update);
			}
			FrameModeChange = false;
		}
		
		if (!Menu.active)
		{
			if (!LevelEditor.active) Mouse.hide();
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
		stopped = true;
		trace("Paused");
	}
	
	public function RegainedFocus(e)
	{
		stopped = false;
		for (i in 0...60)
		{
			prevFPS[i] = 1;
		}
		time = Lib.getTimer();
		trace("Resuming");
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