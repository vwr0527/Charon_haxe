package;

import openfl.display.Sprite;
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
		mainPage.Update();
	}
}