package;

import openfl.display.Sprite;
import menu.MainMenu;
import menu.DebugPage;

/**
 * ...
 * @author Victor Reynolds
 */
class Menu extends Sprite 
{
	private var mainPage:MainMenu;
	private var debugPage:DebugPage;
	
	public function new()
	{
		super();
		
		mainPage = new MainMenu();
		addChild(mainPage);
		debugPage = new DebugPage();
		addChild(debugPage);
	}
	
	public function Update()
	{
		mainPage.Update();
		debugPage.Update();
	}
	
	public function isActive():Bool
	{
		return mainPage.isActive();
	}
}