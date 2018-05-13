package;

import openfl.display.Sprite;
import flash.system.System;
import Input;
import menu.MainPage;

/**
 * ...
 * @author Victor Reynolds
 */
class Menu extends Sprite 
{
	private var mainPage:MainPage;
	
	public function new()
	{
		super();
		
		mainPage = new MainPage();
		addChild(mainPage);
	}
	
	public function Update()
	{
		if (Input.KeyDown(27))
		{
			System.exit(0);
		}
		
		mainPage.Update();
	}
}