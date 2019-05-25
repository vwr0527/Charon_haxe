package menu;
import openfl.Lib;
import openfl.display.Shape;
import openfl.display.Sprite;

/**
 * ...
 * @author 
 */
class HudPage extends MenuPage 
{
	public static var Health:Float = 0;
	public static var Shield:Float = 0;
	public static var Boost:Float = 0;
	
	var healthbar:Sprite;
	var healthbarframe:Shape;
	var healthbarbar:Shape;
	
	var shieldbar:Sprite;
	var shieldbarframe:Shape;
	var shieldbarbar:Shape;
	
	var boostbar:Sprite;
	var boostbarframe:Shape;
	var boostbarbar:Shape;

	public function new() 
	{
		super();
		healthbar = new Sprite();
		shieldbar = new Sprite();
		boostbar = new Sprite();
		
		addChild(healthbar);
		addChild(shieldbar);
		addChild(boostbar);
		
		healthbarframe = new Shape();
		healthbarframe.graphics.lineStyle(2, 0xFF1111);
		healthbarframe.graphics.beginFill(0x990000, 0.5);
		healthbarframe.graphics.drawRect(0, -5, 100, 10);
		healthbarframe.graphics.endFill();
		healthbarbar = new Shape();
		healthbarbar.graphics.beginFill(0xFF0000, 1);
		healthbarbar.graphics.drawRect(0, -5, 100, 10);
		healthbarbar.graphics.endFill();
		healthbar.addChild(healthbarframe);
		healthbar.addChild(healthbarbar);
		healthbar.x = Lib.application.window.width * 0.05;
		healthbar.y = Lib.application.window.height * 0.85;
		
		shieldbarframe = new Shape();
		shieldbarframe.graphics.lineStyle(2, 0x11AAFF);
		shieldbarframe.graphics.beginFill(0x005599, 0.5);
		shieldbarframe.graphics.drawRect(0, -5, 100, 10);
		shieldbarframe.graphics.endFill();
		shieldbarbar = new Shape();
		shieldbarbar.graphics.beginFill(0x00AAFF, 1);
		shieldbarbar.graphics.drawRect(0, -5, 100, 10);
		shieldbarbar.graphics.endFill();
		shieldbar.addChild(shieldbarframe);
		shieldbar.addChild(shieldbarbar);
		shieldbar.x = healthbar.x;
		shieldbar.y = healthbar.y + 20;
		
		boostbarframe = new Shape();
		boostbarframe.graphics.lineStyle(2, 0xFFFF11);
		boostbarframe.graphics.beginFill(0xAAAA00, 0.5);
		boostbarframe.graphics.drawRect(0, -5, 100, 10);
		boostbarframe.graphics.endFill();
		boostbarbar = new Shape();
		boostbarbar.graphics.beginFill(0xFFFF11, 1);
		boostbarbar.graphics.drawRect(0, -5, 100, 10);
		boostbarbar.graphics.endFill();
		boostbar.addChild(boostbarframe);
		boostbar.addChild(boostbarbar);
		boostbar.x = shieldbar.x;
		boostbar.y = shieldbar.y + 20;
	}
	
	public override function Update()
	{
		boostbarbar.scaleX = Boost;
		shieldbarbar.scaleX = Shield;
		healthbarbar.scaleX = Health;
	}
}