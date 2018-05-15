package menu;

import openfl.display.Sprite;

/**
 * ...
 * @author Victor Reynolds
 */
class MenuPage extends Sprite 
{
	private var elements:Array<MenuElement>;
	
	public function new() 
	{
		super();
		
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
}