package;

import menu.DebugPage;
import openfl.display.Sprite;
import openfl.Lib;
import world.Camera;
import world.Entity;
import world.Level;
import world.Player;
import world.Shot;

/**
 * ...
 * @author Victor Reynolds
 */
class World extends Sprite 
{
	private var paused:Bool;
	private var camera:Camera;
	private var player:Player;
	private var entityList:Array<Entity>;
	private var playerShots:Array<Entity>;
	private var enemyShots:Array<Entity>;
	private var enemyList:Array<Entity>;
	private var itemList:Array<Entity>;
	private var newEntities:Array<Entity>;
	private var levelDictionary:Map<String, Level>;
	private var level:Level;
	
	private var shipLayer:Sprite;
	private var shotLayer:Sprite;
	private var levelLayer:Sprite;
	
	private var recycleEntList:Array<Entity>;
	private var entMax = 4000;
	
	public function new() 
	{
		super();
		
		entityList = new Array();
		newEntities = new Array();
		
		recycleEntList = new Array();
		
		player = new Player();
		addChild(player);
		
		if (Main.RecycleMode == false)
		{
			entityList.push(player);
		}
		else
		{
			recycleEntList.push(player);
		}
		playerShots = new Array();
		enemyShots = new Array();
		enemyList = new Array();
		itemList = new Array();
		
		camera = new Camera();
		MoveWorldToCamera();
		
		levelDictionary = new Map();
		LoadLevels();
		
		for (i in 0...entMax - 1)
		{
			var newshot:Shot = new Shot();
			newshot.active = false;
			recycleEntList.push(newshot);
		}
	}
	
	public function Update()
	{
		MoveWorldToCamera();
		
		if (paused) return;
		
		player.LookAt(mouseX, mouseY);
		
		if (Main.RecycleMode == false)
		{
			for (ent in entityList)
			{
				ent.Update(Spawn);
				level.Collide(ent);
			}
			
			for (ent in newEntities)
			{
				entityList.push(ent);
			}
			newEntities = new Array();
			
			var i = entityList.length - 1;
			while (i >= 0)
			{
				if (entityList[i].active == false)
				{
					removeChild(entityList[i]);
					entityList.splice(i, 1);
				}
				--i;
			}
			DebugPage.entcount = entityList.length;
		}
		else
		{
			for (ent in recycleEntList)
			{
				ent.Update(Spawn);
				level.Collide(ent);
			}
			
			DebugPage.entcount = 0;
			for (i in 0...recycleEntList.length)
			{
				if (recycleEntList[i].active == false)
				{
					if (contains(recycleEntList[i])) removeChild(recycleEntList[i]);
				}
				else
				{
					++DebugPage.entcount;
				}
			}
		}
	}
	
	private function Spawn(newEnt:Entity)
	{
		if (Main.RecycleMode == false)
		{
			if (entityList.length < entMax)
			{
				newEntities.push(newEnt);
				addChild(newEnt);
			}
		}
		else
		{
			var i = 0;
			while (i < recycleEntList.length)
			{
				if (recycleEntList[i].active == false)
				{
					recycleEntList[i].active = true;
					recycleEntList[i].x = newEnt.x;
					recycleEntList[i].y = newEnt.y;
					recycleEntList[i].xv = newEnt.xv;
					recycleEntList[i].yv = newEnt.yv;
					recycleEntList[i].rotation = newEnt.rotation;
					addChild(recycleEntList[i]);
					break;
				}
				++i;
			}
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
		this.scaleX = this.scaleY = camera.zoom * (Lib.application.window.height / 480);
	}
	
	private function LoadLevels() 
	{
		levelDictionary.set("test", new Level());
		level = levelDictionary["test"];
	}
}