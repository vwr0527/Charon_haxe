package menu;
import util.LevelEditor;

/**
 * ...
 * @author 
 */
class LevelEditPage extends MenuPage 
{
	var resumeGame:Bool = false;
	
	public function new() 
	{
		super();
		addSelection("resume editing", 0.4);
		addSelection("save level", 0.5);
		addSelection("load level", 0.6);
		addSelection("end level editor", 0.8);
		super.Update();
	}
	
	private function addSelection(name:String, ypos:Float)
	{
		var selection = new MenuElement();
		selection.AddBitmapText(name, "fonts/fcubef2.png");
		selection.ypos = ypos;
		Add(selection);
	}
	
	public override function Update()
	{
		super.Update();
		
		for (i in 0...(elements.length))
		{
			var elem:MenuElement = elements[i];
			
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
		
		if (Input.KeyDown(27))
		{
			changePage = true;
			LevelEditor.active = false;
			nextPage = "mainPage";
		}
	}
}