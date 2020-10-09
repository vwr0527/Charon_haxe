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
		bgeSelector.AddBitmapText("bgeSelector", "fonts/fcubef2.png");
		bgeSelector.xpos = 0.1;
		bgeSelector.ypos = 0.1;
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
			levelEditor.StopBgePulse(1); //test
			
			for (hudelem in hudElems)
			{
				hudelem.visible = false;
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
			for (hudelem in hudElems)
			{
				hudelem.Update();
				hudelem.visible = true;
			}
			for (elem in menuElems)
			{
				elem.visible = false;
			}
			
			//test
			if (bgeSelector.hitTestPoint(mouseX, mouseY))
			{
				levelEditor.MakeBgePulse(1); //test
			}
			else
			{
				levelEditor.StopBgePulse(1); //test
			}
		}
			
		if (Input.KeyDown(27))
		{
			menuMode = !menuMode;
		}
	}
	
	override public function SetVisible(vis:Bool) 
	{
		menuMode = vis;
	}
}