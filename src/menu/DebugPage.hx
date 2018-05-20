package menu;

import Main;

/**
 * ...
 * @author Victor Reynolds
 */
class DebugPage extends MenuPage 
{
	var counter:MenuElement;
	
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
	}
}