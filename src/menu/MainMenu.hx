package menu;

import Input;
import openfl.system.System;

/**
 * ...
 * @author Victor Reynolds
 */
class MainMenu extends MenuPage 
{
	public function new() 
	{
		super();
		
		var t = new MenuElement();
		t.AddText("Counter: ", "fonts/pirulen.ttf", 12, 0xaabb55);
		t.xpos = 0;
		t.ypos = 0;
		Add(t);
		
		var g = new MenuElement();
		g.AddBitmapText("PRESS ESC FOR MENU", "fonts/mmx.png");
		g.ypos = 0.1;
		Add(g);
		
		var a = new MenuElement();
		a.AddBitmapText("CHARON", "fonts/robocop_font.png", "center", 8);
		a.ypos = 0.15;
		a.visible = false;
		Add(a);
		
		var b = new MenuElement();
		b.AddBitmapText("resume", "fonts/fcubef2.png");
		b.ypos = 0.4;
		b.visible = false;
		Add(b);
		
		var c = new MenuElement();
		c.AddBitmapText("new game", "fonts/fcubef2.png");
		c.ypos = 0.5;
		c.visible = false;
		Add(c);
		
		var d = new MenuElement();
		d.AddBitmapText("load game", "fonts/fcubef2.png");
		d.ypos = 0.6;
		d.visible = false;
		Add(d);
		
		var e = new MenuElement();
		e.AddBitmapText("options", "fonts/fcubef2.png");
		e.ypos = 0.7;
		e.visible = false;
		Add(e);
		
		var f = new MenuElement();
		f.AddBitmapText("exit", "fonts/fcubef2.png");
		f.ypos = 0.8;
		f.visible = false;
		Add(f);
	}
	
	var count = 0;
	public override function Update()
	{
		super.Update();
		++count;
		elements[0].textField.text = "Counter: " + count;
		
		var toggleMenu:Bool = Input.KeyDown(27);
		
		for (i in 3...(elements.length))
		{
			var elem:MenuElement = elements[i];
			
			if (elem.hitTestPoint(mouseX, mouseY))
			{
				elem.alpha = 0.5;
				
				if (Input.MouseDown())
				{
					switch (i) 
					{
						case 3:
							toggleMenu = true;
						case 7:
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
			for (i in 1...(numChildren))
			{
				getChildAt(i).visible = !getChildAt(i).visible;
			}
		}
	}
}