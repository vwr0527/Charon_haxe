package menu;

/**
 * ...
 * @author Victor Reynolds
 */
class DebugPage extends MenuPage 
{
	var counter:MenuElement;
	var count = 0;
	
	public function new() 
	{
		super();
		
		counter = new MenuElement();
		counter.AddText("Counter: ", "fonts/pirulen.ttf", 12, 0xaabb55);
		counter.xpos = 0;
		counter.ypos = 0;
		Add(counter);
	}
	
	public override function Update()
	{
		super.Update();
		++count;
		counter.textField.text = "Counter: " + count;
	}
}