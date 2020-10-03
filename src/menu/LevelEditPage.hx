package menu;
import util.LevelEditor;

/**
 * ...
 * @author 
 */
class LevelEditPage extends MenuPage 
{
	public function new() 
	{
		super();
		super.Update();
	}
	
	public override function Update()
	{
		super.Update();
		if (Input.KeyDown(27))
		{
			changePage = true;
			nextPage = "mainPage";
		}
	}
}