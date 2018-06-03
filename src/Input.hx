package;

import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import openfl.display.Shape;
import haxe.ds.Vector;

/**
 * ...
 * @author Victor Reynolds
 */
class Input extends Sprite 
{
	private static var mouseDown:Int;
	private static var wheelDelta:Int;
	private static var keyDown:Vector<Int>;
	private var keyBuf:Array<Int>;
	private var cover:Shape;
	
	public function new()
	{
		super();
		//0 = mouse/key is up
		//2 = mouse/key has just been pressed
		//1 = mouse/key is holding down
		//3 = mouse/key was released
		mouseDown = 0;
		wheelDelta = 0;
		keyDown = new Vector(256);
		for (i in 0...256) keyDown[i] = 0;
		keyBuf = new Array();
		
		cover = new Shape();
		cover.graphics.beginFill(0x00000000);
		cover.graphics.drawRect(-4000, -4000, 8000, 8000);
		cover.graphics.endFill();
		cover.alpha = 0;
		addChild(cover);
		
		addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	public function Update()
	{
		if (mouseDown == 2)
			mouseDown = 1;
		else
		if (mouseDown == 3)
			mouseDown = 0;
			
		if (wheelDelta != 0)
			wheelDelta = 0;
			
		while (keyBuf.length > 0)
		{
			var keyCode = keyBuf.pop();
			if (keyDown[keyCode] == 2)
				keyDown[keyCode] = 1;
			else
			if (keyDown[keyCode] == 3)
				keyDown[keyCode] = 0;
		}
	}
	
	private function addedToStageHandler(e)
	{
		stage.focus = this;
	}
	
	private function mouseDownHandler(e)
	{
		if (mouseDown == 0)
			mouseDown = 2;
		stage.focus = this;
	}
	
	private function mouseUpHandler(e)
	{
		mouseDown = 3;
	}
	
	private function mouseWheelHandler(e)
	{
		if (e.delta > 0)
		{
			wheelDelta = 1;
		}
		if (e.delta < 0)
		{
			wheelDelta = -1;
		}
	}
	
	private function keyDownHandler(e)
	{
		if (keyDown[e.keyCode] == 0)
		{
			keyDown[e.keyCode] = 2;
			keyBuf.push(e.keyCode);
		}
	}
	
	private function keyUpHandler(e)
	{
		keyDown[e.keyCode] = 3;
		keyBuf.push(e.keyCode);
	}
	
	//============= Global Accessors =============
	
	// Keyboard
	
	public static function KeyDown(keyCode)
	{
		return keyDown[keyCode] == 2;
	}
	
	public static function KeyHeld(keyCode)
	{
		return keyDown[keyCode] == 1 || keyDown[keyCode] == 2;
	}
	
	public static function KeyUp(keyCode)
	{
		return keyDown[keyCode] == 3;
	}
	
	// Mouse
	
	public static function MouseDown()
	{
		return mouseDown == 2;
	}
	
	public static function MouseHeld()
	{
		return mouseDown == 1 || mouseDown == 2;
	}
	
	public static function MouseUp()
	{
		return mouseDown == 3;
	}
}