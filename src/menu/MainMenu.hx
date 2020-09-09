package menu;

import Input;
import openfl.system.System;

/**
 * ...
 * @author Victor Reynolds
 */
class MainMenu extends MenuPage 
{
	var info:MenuElement;
	var resumeGame:Bool = false;
	var switchToOptions:Bool = false;
	
	public function new() 
	{
		super();
		
		addSelection("resume", 0.4);
		addSelection("new game", 0.5);
		addSelection("load game", 0.6);
		addSelection("options", 0.7);
		addSelection("edit level", 0.8);
		
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
						case 0:
							resumeGame = true;
						case 3:
							switchToOptions = true;
						case 4:
							System.exit(0);
					}
				}
			}
			else
			{
				elem.alpha = 1.0;
			}
		}
	}
	
	public function SwitchToOptions():Bool
	{
		if (switchToOptions)
		{
			switchToOptions = false;
			return true;
		}
		return false;
	}
	
	public function ResumeGame():Bool
	{
		if (resumeGame)
		{
			resumeGame = false;
			return true;
		}
		return false;
	}
}