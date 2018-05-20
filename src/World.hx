package;

import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.Lib;
import world.Entity;
import world.Player;
import world.Shot;

/**
 * ...
 * @author Victor Reynolds
 */
class World extends Sprite 
{
	private var paused:Bool;
	private var player:Player;
	private var shot:Shot;
	private var camera:Point;
	private var zoom:Float;
	private var entities:Array<Entity>;
	
	public function new() 
	{
		super();
		
		entities = new Array();
		
		shot = new Shot();
		addChild(shot);
		entities.push(shot);
		shot.x = 400;
		shot.visible = false;
		
		player = new Player();
		addChild(player);
		entities.push(player);
		
		camera = new Point(0, 0);
		zoom = 1;
		MoveWorldToCamera();
	}
	
	var shootCooldown:Int = 20;
	
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
		
		if (Input.MouseDown() && shootCooldown > 20)
		{
			shot.x = player.x;
			shot.y = player.y;
			shot.xv = 50 * Math.sin((180 - player.rotation) * (Math.PI / 180));
			shot.yv = 50 * Math.cos((180 - player.rotation) * (Math.PI / 180));
			shot.x += shot.xv;
			shot.y += shot.yv;
			shot.rotation = player.rotation;
			shootCooldown = 0;
		}
		
		shootCooldown += 1;
		
		if (shot.x >= 400 || shot.x <= -400 || shot.y >= 240 || shot.y <= -240) shot.visible = false; else shot.visible = true;
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