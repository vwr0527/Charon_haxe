package;

import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.Lib;
import world.Entity;
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
	private var entities:Array<Entity>;
	
	public function new() 
	{
		super();
		
		camera = new Point(0, 0);
		zoom = 1;
		player = new Player();
		addChild(player);
		entities = new Array();
		entities.push(player);
		
		MoveWorldToCamera();
	}
	
	public function Update()
	{
		MoveWorldToCamera();
		
		player.LookAt(mouseX, mouseY);
		
		for (ent in entities)
		{
			ent.Update();
		}
	}
	
	private function MoveWorldToCamera()
	{
		this.x = -camera.x + Lib.application.window.width / 2;
		this.y = -camera.y + Lib.application.window.height / 2;
		this.scaleX = this.scaleY = zoom * (Lib.application.window.height / 480);
	}
}