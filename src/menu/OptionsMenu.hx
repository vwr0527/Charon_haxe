package menu;

import Input;
import openfl.system.System;

/**
 * ...
 * @author Victor Reynolds
 */
class OptionsMenu extends MenuPage 
{
	var title:MenuElement;
	var info:MenuElement;
	var returnToMainMenu:Bool = false;
	
	public function new() 
	{
		super();
		
		addSelection("option 1", 0.4);
		addSelection("option 2", 0.5);
		addSelection("option 3", 0.6);
		addSelection("option 4", 0.7);
		addSelection("main menu", 0.8);
		
		super.Update();
	}
	
	private function addSelection(name:String, ypos:Float)
	{
		var selection = new MenuElement();
		selection.AddBitmapText(name, "fonts/fcubef2.png");
		selection.ypos = ypos;
		Add(selection);
	}
	
	public override function Update()
	{
		super.Update();
		
		if (Input.KeyDown(27)) returnToMainMenu = true;
		
		for (i in 0...(elements.length))
		{
			var elem:MenuElement = elements[i];
			
			if (elem.hitTestPoint(mouseX, mouseY))
			{
				elem.alpha = 0.5;
				
				if (Input.MouseUp())
				{
					switch (i) 
					{
						case 4:
							returnToMainMenu = true;
					}
				}
			}
			else
			{
				elem.alpha = 1.0;
			}
		}
	}
	
	public function ReturnToMainMenu():Bool
	{
		if (returnToMainMenu)
		{
			returnToMainMenu = false;
			return true;
		}
		return false;
	}
}