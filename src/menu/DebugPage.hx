package menu;

import Main;
import openfl.system.System;

/**
 * ...
 * @author Victor Reynolds
 */
class DebugPage extends MenuPage 
{
	var counter:MenuElement;
	
	public static var entcount:Int = 0;
	
	public function new() 
	{
		super();
		
		counter = new MenuElement();
		counter.AddText("FPS: 0", "fonts/pirulen.ttf", 12, 0xaabb55);
		counter.xpos = 0;
		counter.ypos = 0;
		Add(counter);
		
		super.Update();
	}
	
	public override function Update()
	{
		super.Update();
		
		counter.textField.text = "fps: " + Main.getFPS();
		counter.textField.text += "\nents: " + entcount;
		counter.textField.text += "\nmem: " + Math.floor(System.totalMemory / 1000000.0);
	}
}