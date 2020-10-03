package;

import menu.LevelEditPage;
import menu.MenuPage;
import menu.OptionsMenu;
import menu.TitlePage;
import openfl.display.Sprite;
import menu.MainMenu;
import menu.DebugPage;
import menu.HudPage;
import openfl.utils.Dictionary;

/**
 * ...
 * @author Victor Reynolds
 */
class Menu extends Sprite 
{
	private var menuPages:Dictionary<String, MenuPage>;
	private var titlePage:TitlePage;
	private var mainPage:MainMenu;
	private var optionsPage:OptionsMenu;
	private var levelEditPage:LevelEditPage;
	private var pressEsc:TitlePage;
	private var debugPage:DebugPage;
	private var hudPage:HudPage;
	
	public var isActive = false;
	private var currentPage:MenuPage;
	
	public function new()
	{
		super();
		
		menuPages = new Dictionary<String, MenuPage>();
		
		hudPage = new HudPage();
		addChild(hudPage);
		
		titlePage = new TitlePage();
		addChild(titlePage);
		
		mainPage = new MainMenu();
		addChild(mainPage);
		menuPages.set("mainPage", mainPage);
		
		optionsPage = new OptionsMenu();
		menuPages.set("optionsPage", optionsPage);
		
		debugPage = new DebugPage();
		addChild(debugPage);
		
		levelEditPage = new LevelEditPage();
		menuPages.set("levelEditPage", levelEditPage);
		
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
			currentPage.visible = true;
			
			if (currentPage.ChangePage())
			{
				removeChild(currentPage);
				currentPage = menuPages[currentPage.NextPage()];
				addChild(currentPage);
				
				if (currentPage == levelEditPage)
				{
					titlePage.ShowLevelEditTip(true);
				}
				else
				{
					titlePage.ShowLevelEditTip(false);
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