package;

import menu.MenuPage;
import menu.OptionsMenu;
import menu.TitlePage;
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
	private var menuPages:Array<MenuPage>;
	private var titlePage:TitlePage;
	private var mainPage:MainMenu;
	private var optionsPage:OptionsMenu;
	private var pressEsc:TitlePage;
	private var debugPage:DebugPage;
	private var hudPage:HudPage;
	
	public var isActive = false;
	private var currentPage:MenuPage;
	
	public function new()
	{
		super();
		
		menuPages = new Array<MenuPage>();
		
		hudPage = new HudPage();
		addChild(hudPage);
		
		titlePage = new TitlePage();
		addChild(titlePage);
		
		mainPage = new MainMenu();
		addChild(mainPage);
		menuPages.push(mainPage);
		mainPage.visible = false;
		
		optionsPage = new OptionsMenu();
		addChild(optionsPage);
		menuPages.push(optionsPage);
		optionsPage.visible = false;
		
		debugPage = new DebugPage();
		addChild(debugPage);
		
		currentPage = mainPage;
	}
	
	public function Update()
	{
		hudPage.Update();
		debugPage.Update();
		
		if (isActive)
		{
			titlePage.SetVisible(true);
			if (mainPage.ResumeGame()) isActive = false;
			if (mainPage.SwitchToOptions()) currentPage = optionsPage;
			if (optionsPage.ReturnToMainMenu()) currentPage = mainPage;
			
			for (page in menuPages)
			{
				page.visible = false;
				if (page == currentPage)
				{
					page.visible = true;
				}
			}
			currentPage.Update();
			if (Input.KeyDown(27) && currentPage == mainPage) isActive = false;
		}
		else
		{
			titlePage.SetVisible(false);
			currentPage.visible = false;
			if (Input.KeyDown(27)) isActive = true;
		}
	}
}