package menu;

/**
 * ...
 * @author Victor Reynolds
 */
class TitlePage extends MenuPage 
{
	var info:MenuElement;
	var title:MenuElement;
	
	public function new() 
	{
		super();
		
		info = new MenuElement();
		info.AddBitmapText("PRESS ESC FOR MENU", "fonts/mmx.png");
		info.ypos = 0.1;
		Add(info);
		
		title = new MenuElement();
		title.AddBitmapText("CHARON", "fonts/robocop_font.png", "center", 8);
		title.ypos = 0.15;
		title.visible = false;
		Add(title);
		
		super.Update();
	}
	
	public function SetVisible(titleVisible:Bool)
	{
		title.visible = titleVisible;
		info.visible = !title.visible;
	}
}