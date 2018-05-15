package menu;

import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Victor Reynolds
 */
class MainMenu extends MenuPage 
{
	var a:MenuElement;
	var b:MenuElement;
	var c:MenuElement;
	var t:MenuElement;
	
	public function new() 
	{
		super();
		
		t = new MenuElement();
		t.AddText("", "fonts/pirulen.ttf", 24, TextFormatAlign.LEFT);
		t.xpos = 0;
		t.ypos = 0;
		t.size = 0.5;
		Add(t);
		
		a = new MenuElement();
		a.AddBitmapText("BITMAP FONT", "fonts/robocop_font.png");
		a.ypos = 0.75;
		Add(a);
		
		b = new MenuElement();
		b.AddBitmapText("the quick brown fox jumps over the lazy dog", "fonts/fcubef2.png");
		b.ypos = 0.25;
		Add(b);
		
		c = new MenuElement();
		c.AddBitmapText("how does this font look? it's called 9085", "fonts/9085_font2.png");
		c.ypos = 0.85;
		c.size = 2;
		Add(c);
	}
	
	var count = 0;
	public override function Update()
	{
		super.Update();
		++count;
		t.textField.text = "Counter: " + count;
	}
}