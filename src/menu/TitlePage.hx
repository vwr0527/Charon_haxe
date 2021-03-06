package menu;

/**
 * ...
 * @author Victor Reynolds
 */
class TitlePage extends MenuPage 
{
	var info:MenuElement;
	var info2:MenuElement;
	var title:MenuElement;
	
	public function new() 
	{
		super();
		
		info = new MenuElement();
		info.AddBitmapText("PRESS ESC FOR MENU", "fonts/mmx.png");
		info.ypos = 0.1;
		Add(info);
			
		info2 = new MenuElement();
		info2.AddBitmapText("Level Editor", "fonts/mmx.png");
		info2.ypos = 0.05;
		Add(info2);
		info2.visible = false;
		
		title = new MenuElement();
		title.AddBitmapText("CHARON", "fonts/robocop_font.png", "center", 8);
		title.ypos = 0.15;
		title.visible = false;
		Add(title);
		
		super.Update();
	}
	
	public override function SetVisible(titleVisible:Bool)
	{
		title.visible = titleVisible;
		info.visible = !title.visible;
	}
	
	public function ShowLevelEditTip(show:Bool)
	{
		info2.visible = show;
	}
}