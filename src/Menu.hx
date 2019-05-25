package;

import openfl.display.Sprite;
import menu.MainMenu;
import menu.DebugPage;
import menu.HudPage;

/**
 * ...
 * @author Victor Reynolds
 */
class Menu extends Sprite 
{
	private var mainPage:MainMenu;
	private var debugPage:DebugPage;
	private var hudPage:HudPage;
	
	public function new()
	{
		super();
		
		hudPage = new HudPage();
		addChild(hudPage);
		mainPage = new MainMenu();
		addChild(mainPage);
		debugPage = new DebugPage();
		addChild(debugPage);
	}
	
	public function Update()
	{
		hudPage.Update();
		mainPage.Update();
		debugPage.Update();
	}
	
	public function isActive():Bool
	{
		return mainPage.isActive();
	}
}