package menu;
import haxe.Constraints.Function;
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
	
	var optionMouseOver:Bool = false;
	var currentWidget:String = "";
	var widgets:Map<String, Widget>;
	
	public function new(leveledit:LevelEditor) 
	{
		menuElems = new Array<MenuElement>();
		hudElems = new Array<MenuElement>();
		widgets = new Map<String, Widget>();
		levelEditor = leveledit;
		
		super();
		AddMenuSelection("resume editing", 0.4);
		AddMenuSelection("save level", 0.5);
		AddMenuSelection("load level", 0.6);
		AddMenuSelection("end level editor", 0.8);
		super.Update();
		
		AddWidget("bgeselector", 0.2, levelEditor.BGESelector, levelEditor.DeselectAllBGE);
		AddWidget("trianglecreator", 0.25, levelEditor.TriangleCreator, levelEditor.CancelTriangleCreator);
		AddWidget("tileselector", 0.3, levelEditor.TileSelector, levelEditor.CancelTileSelect);
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
	
	private function AddWidget(myName:String, ypos:Float, doFunc:Function, cancelFunc:Function)
	{
		var newMenuElement = new MenuElement();
		newMenuElement.AddBitmapText(myName, "fonts/fcubef2.png", "left");
		newMenuElement.xpos = 0.01;
		newMenuElement.ypos = ypos;
		var newWidget:Widget;
		newWidget = {
			name : myName,
			menuElement : newMenuElement,
			modeActive : false,
			doFunction : doFunc,
			doCancel: cancelFunc
		};
		AddHudElem(newMenuElement);
		widgets.set(myName, newWidget);
	}
	
	public override function Update()
	{
		if (menuMode)
		{
			for (widget in widgets)
			{
				widget.doCancel();
			}
			
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
			
			UpdateWidgets();
		}
			
		if (Input.KeyDown(27))
		{
			menuMode = !menuMode;
		}
	}
	
	private function UpdateWidgets()
	{
		optionMouseOver = false;
		
		//show outline of moused over option, and activate the clicked on option
		for (widget in widgets) {
			if (widget.menuElement.hitTestPoint(mouseX, mouseY))
			{
				optionMouseOver = true;
				widget.menuElement.ShowOutline();
				if (Input.MouseUp())
				{
					widget.modeActive = !widget.modeActive;
					currentWidget = widget.name;
				}
			}
			else
			{
				widget.menuElement.HideOutline();
			}
		}
		
		//if clicked one of the options, deselect the others
		for (widget in widgets) {
			if (widget.name != currentWidget) {
				if (Input.MouseUp() && optionMouseOver)
				{
					widget.modeActive = false;
				}
			}
		}
		
		//if an option is active, and not selecting any option, then do its edit level function
		//any deselected option does its deselect function
		for (widget in widgets) {
			if (widget.modeActive)
			{
				widget.menuElement.ShowOutline();
				if (!optionMouseOver)
				{
					widget.doFunction();
				}
			} else {
				widget.doCancel();
			}
		}
	}
	
	override public function SetVisible(vis:Bool) 
	{
		menuMode = vis;
	}
}

typedef Widget =
{
	var name:String;
	var menuElement:MenuElement;
	var modeActive:Bool;
	var doFunction:Function;
	var doCancel:Function;
}