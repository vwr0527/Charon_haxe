package menu;

import Input;
import openfl.system.System;

/**
 * ...
 * @author Victor Reynolds
 */
class MainMenu extends MenuPage 
{
	var title:MenuElement;
	var info:MenuElement;
	
	public function new() 
	{
		super();
		
		info = new MenuElement();
		info.AddBitmapText("PRESS ESC FOR MENU", "fonts/mmx.png");
		info.ypos = 0.1;
		Add(info);
		
		title = new MenuElement();
		title.AddBitmapText("CHARON", "fonts/robocop_font.png", "center", 8);
		title.ypos = 0.15;
		title.visible = false;
		Add(title);
		
		addSelection("resume", 0.4);
		addSelection("new game", 0.5);
		addSelection("load game", 0.6);
		addSelection("options", 0.7);
		addSelection("exit", 0.8);
		
		super.Update();
	}
	
	private function addSelection(name:String, ypos:Float)
	{
		var selection = new MenuElement();
		selection.AddBitmapText(name, "fonts/fcubef2.png");
		selection.ypos = ypos;
		selection.visible = false;
		Add(selection);
	}
	
	public override function Update()
	{
		super.Update();
		
		var toggleMenu:Bool = Input.KeyDown(27);
		
		for (i in 2...(elements.length))
		{
			var elem:MenuElement = elements[i];
			
			if (elem.hitTestPoint(mouseX, mouseY))
			{
				elem.alpha = 0.5;
				
				if (Input.MouseDown())
				{
					switch (i) 
					{
						case 2:
							toggleMenu = true;
						case 6:
							System.exit(0);
					}
				}
			}
			else
			{
				elem.alpha = 1.0;
			}
		}
		
		if (toggleMenu)
		{
			for (i in 0...(numChildren))
			{
				getChildAt(i).visible = !getChildAt(i).visible;
			}
		}
	}
}