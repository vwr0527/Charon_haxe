package menu;

import openfl.display.Sprite;

/**
 * ...
 * @author Victor Reynolds
 */
class MenuPage extends Sprite 
{
	private var elements:Array<MenuElement>;
	private var changePage:Bool;
	private var nextPage:String;
	
	public function new() 
	{
		super();
		changePage = false;
		nextPage = "";
		elements = new Array();
	}
	
	public function Update()
	{
		for (elem in elements)
		{
			elem.Update();
		}
	}
	
	public function Add(elem:MenuElement)
	{
		elements.push(elem);
		addChild(elem);
	}
	
	public function SetVisible(vis:Bool)
	{
		this.visible = vis;
	}
	
	public function ChangePage():Bool
	{
		return changePage;
	}
	
	public function NextPage():String
	{
		changePage = false;
		return nextPage;
	}
}