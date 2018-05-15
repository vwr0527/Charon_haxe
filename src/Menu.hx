package;

import openfl.display.Sprite;
import flash.system.System;
import Input;
import menu.MainMenu;

/**
 * ...
 * @author Victor Reynolds
 */
class Menu extends Sprite 
{
	private var mainPage:MainMenu;
	
	public function new()
	{
		super();
		
		mainPage = new MainMenu();
		addChild(mainPage);
	}
	
	public function Update()
	{
		if (Input.KeyDown(27))
		{
			this.visible = !this.visible;
		}
		
		mainPage.Update();
	}
}