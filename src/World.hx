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
	private var paused:Bool;
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
		
		if (paused) return;
		
		player.LookAt(mouseX, mouseY);
		
		for (ent in entities)
		{
			ent.Update();
			Confine(ent, -400, 400, -240, 240);
		}
	}
	
	public function Pause()
	{
		paused = true;
	}
	
	public function Unpause()
	{
		paused = false;
	}
	
	private function MoveWorldToCamera()
	{
		this.x = -camera.x + Lib.application.window.width / 2;
		this.y = -camera.y + Lib.application.window.height / 2;
		this.scaleX = this.scaleY = zoom * (Lib.application.window.height / 480);
	}
	
	private function Confine(ent:Entity, xmin:Float, xmax:Float, ymin:Float, ymax:Float)
	{
		if (ent.x < xmin)
		{
			ent.xv = 0;
			ent.x = xmin;
		}
		if (ent.x > xmax)
		{
			ent.xv = 0;
			ent.x = xmax;
		}
		if (ent.y < ymin)
		{
			ent.yv = 0;
			ent.y = ymin;
		}
		if (ent.y > ymax)
		{
			ent.yv = 0;
			ent.y = ymax;
		}
	}
}