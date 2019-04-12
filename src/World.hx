package;

import menu.DebugPage;
import openfl.Lib;
import openfl.display.Sprite;
import world.Camera;
import world.Enemy;
import world.Entity;
import world.Level;
import world.Shot;
import world.levels.TestLevel1;
import world.Player;

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
	//private var playerShots:Array<Entity>;
	//private var enemyShots:Array<Entity>;
	//private var enemyList:Array<Enemy>;
	//private var itemList:Array<Entity>;
	private var newEntities:Array<Entity>;
	private var levelDictionary:Map<String, Level>;
	private var level:Level;
	
	private var shipLayer:Sprite;
	private var shotLayer:Sprite;
	private var levelLayer:Sprite;
	
	private var entMax = 4000;
	
	public function new() 
	{
		super();
		
		entityList = new Array();
		newEntities = new Array();
		
		player = new Player();
		entityList.push(player);
		
		//playerShots = new Array();
		//enemyShots = new Array();
		//enemyList = new Array();
		//itemList = new Array();
		
		camera = new Camera();
		MoveWorldToCamera();
		
		levelDictionary = new Map();
		LoadLevels();
		
		addChild(player);
		Spawn(new Enemy());
	}
	
	public function Update()
	{
		MoveWorldToCamera();
		MoveCameraToPlayer();
		
		if (paused) return;
		
		player.LookAt(mouseX, mouseY);
		
		for (ent in entityList)
		{
			ent.Update(Spawn);
			ent.LevelCollide(level);
			
			if (Std.is(ent, Enemy))
			{
				cast(ent, Enemy).LookAt(player.x, player.y);
			}
		}
		
		/*
		for (enemy in enemyList)
		{
			enemy.LookAt(player.x, player.y);
		}
		*/
		
		for (ent in newEntities)
		{
			/*
			if (Std.is(ent, Enemy))
			{
				enemyList.push(cast(ent, Enemy));
			}
			*/
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
				
				/*
				if (Std.is(entityList[i], Enemy))
				{
					var enemy:Enemy = cast(entityList[i], Enemy);
					var enemyIndex:Int = enemyList.indexOf(enemy);
					if (enemyIndex != -1)
					{
						enemyList.splice(enemyIndex, 1);
					}
				}
				*/
			}
			--i;
		}
		DebugPage.entcount = entityList.length;
		
		level.Update();
		if (level.SwitchedRoom())
		{
			player.x = level.SwitchRoomPlayerPosX();
			player.y = level.SwitchRoomPlayerPosY();
			camera.x = player.x;
			camera.y = player.y;
			MoveWorldToCamera();
			
			//StoreEntsInRoom(level.previousRoom);
			//RemoveAllEnts();
			//LoadEntsFromRoom(level.currentRoom);
		}
	}
	
	private function Spawn(newEnt:Entity)
	{
		if (entityList.length < entMax)
		{
			newEntities.push(newEnt);
			addChild(newEnt);
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
		this.scaleX = this.scaleY = camera.zoom * (Lib.application.window.height / 540);
	}
	
	private function MoveCameraToPlayer() 
	{
		camera.x += (player.x - camera.x) / 20;
		camera.y += (player.y - camera.y) / 20;
	}
	
	private function LoadLevels() 
	{
		var testLevel1 = new TestLevel1();
		level = testLevel1.level;
		levelDictionary.set("test", level);
		addChild(level);
		
		player.x = level.StartRoom().playerSpawnX;
		player.y = level.StartRoom().playerSpawnY;
	}
}