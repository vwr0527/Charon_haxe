package menu;
import util.LevelEditor;

/**
 * ...
 * @author 
 */
class LevelEditPage extends MenuPage 
{
	var menuMode:Bool = true;
	var menuElems:Array<MenuElement>;
	var hudElems:Array<MenuElement>;
	
	var levelEditor:LevelEditor;
	
	var bgeSelector:MenuElement;
	var bgeSelectorMode:Bool = false;
	
	public function new(leveledit:LevelEditor) 
	{
		menuElems = new Array<MenuElement>();
		hudElems = new Array<MenuElement>();
		
		super();
		AddMenuSelection("resume editing", 0.4);
		AddMenuSelection("save level", 0.5);
		AddMenuSelection("load level", 0.6);
		AddMenuSelection("end level editor", 0.8);
		super.Update();
		
		bgeSelector = new MenuElement();
		bgeSelector.AddBitmapText("bgeselector", "fonts/fcubef2.png");
		bgeSelector.xpos = 0.1;
		bgeSelector.ypos = 0.2;
		AddHudElem(bgeSelector);
		
		levelEditor = leveledit;
	}
	
	private function AddMenuSelection(name:String, ypos:Float)
	{
		var selection = new MenuElement();
		selection.AddBitmapText(name, "fonts/fcubef2.png");
		selection.ypos = ypos;
		addChild(selection);
		menuElems.push(selection);
	}
	
	private function AddHudElem(elem:MenuElement)
	{
		addChild(elem);
		hudElems.push(elem);
	}
	
	public override function Update()
	{
		if (menuMode)
		{
			levelEditor.DeselectAllBGE(); //test
			
			for (hudElem in hudElems)
			{
				hudElem.visible = false;
			}
			for (i in 0...(menuElems.length))
			{
				var elem:MenuElement = menuElems[i];
				elem.Update();
				elem.visible = true;
				
				if (elem.hitTestPoint(mouseX, mouseY))
				{
					elem.alpha = 0.5;
					
					if (Input.MouseUp())
					{
						switch (i)
						{
							case 0:
								Menu.active = false;
							case 3:
								changePage = true;
								LevelEditor.active = false;
								nextPage = "mainPage";
						}
					}
				}
				else
				{
					elem.alpha = 1.0;
				}
			}
		}
		else
		{
			for (hudElem in hudElems)
			{
				hudElem.Update();
				hudElem.visible = true;
			}
			for (elem in menuElems)
			{
				elem.visible = false;
			}
			
			//test
			if (bgeSelector.hitTestPoint(mouseX, mouseY) && Input.MouseUp())
			{
				bgeSelectorMode = !bgeSelectorMode;
			}
		}
			
		if (Input.KeyDown(27))
		{
			menuMode = !menuMode;
		}
		
		if (bgeSelectorMode)
		{
			bgeSelector.ShowOutline();
			levelEditor.BGESelector(mouseX, mouseY);
		} else {
			bgeSelector.HideOutline();
			levelEditor.DeselectAllBGE();
		}
	}
	
	override public function SetVisible(vis:Bool) 
	{
		menuMode = vis;
	}
}