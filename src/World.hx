package;

import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.Lib;
import world.Player;

/**
 * ...
 * @author Victor Reynolds
 */
class World extends Sprite 
{
	private var player:Player;
	private var camera:Point;
	private var zoom:Float;

	public function new() 
	{
		super();
		
		camera = new Point(0, 0);
		zoom = 1;
		
		player = new Player();
		addChild(player);
	}
	
	public function Update()
	{
		// camera
		this.x = -camera.x + Lib.application.window.width / 2;
		this.y = -camera.y + Lib.application.window.height / 2;
		this.scaleX = this.scaleY = zoom * (Lib.application.window.height / 480);
		
		player.Update();
	}
}