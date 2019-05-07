package;

import menu.DebugPage;
import openfl.Lib;
import openfl.display.Sprite;
import util.LevelParser;
import world.Camera;
import world.Enemy;
import world.Entity;
import world.Explosion;
import world.Level;
import world.LevelRoom;
import world.Shot;
import world.Player;

/**
 * ...
 * @author Victor Reynolds
 */
class World extends Sprite 
{
	private var paused:Bool;
	private var camera:Camera;
	public static var shake:Float;
	private var cross1:Crosshair;
	private var cross2:Crosshair;
	private var cross3:Crosshair;
	private var crossi:Crosshair;
	private var player:Player;
	private var entityList:Array<Entity>;
	private var playerShots:Array<Shot>;
	private var enemyShots:Array<Shot>;
	private var enemyList:Array<Enemy>;
	private var itemList:Array<Entity>;
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
		
		playerShots = new Array();
		enemyShots = new Array();
		enemyList = new Array();
		itemList = new Array();
		
		camera = new Camera();
		MoveWorldToCamera();
		
		cross1 = new Crosshair();
		cross1.CreatePrimaryCrosshair();
		addChild(cross1);
		
		cross2 = new Crosshair();
		cross2.CreateSecondaryCrosshair();
		addChild(cross2);
		
		cross3 = new Crosshair();
		cross3.CreateTertiaryCrosshair();
		addChild(cross3);
		
		crossi = new Crosshair();
		
		shake = 0.0;
		
		levelDictionary = new Map();
		LoadLevels();
		
		addChild(player);
		
		LoadEntsFromRoom(level.currentRoom);
	}
	
	public function Update()
	{
		if (paused) return;
		
		player.LookAt(mouseX, mouseY);
		
		for (ent in entityList)
		{
			ent.Update(Spawn);
			ent.LevelCollide(level);
		}
		
		for (enemy in enemyList)
		{
			enemy.LookAt(player.x, player.y);
			for (shot in playerShots)
			{
				if (!shot.AlreadyHit()) enemy.CheckShotHit(shot);
			}
		}
		
		for (ent in newEntities)
		{
			if (Std.is(ent, Enemy))
			{
				enemyList.push(cast(ent, Enemy));
			} else 
			if (Std.is(ent, Shot))
			{
				playerShots.push(cast(ent, Shot));
			}
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
		
		i = enemyList.length - 1;
		while (i >= 0)
		{
			if (enemyList[i].active == false)
			{
				enemyList.splice(i, 1);
			}
			--i;
		}
		
		i = playerShots.length - 1;
		while (i >= 0)
		{
			if (playerShots[i].active == false)
			{
				playerShots.splice(i, 1);
			}
			--i;
		}
		
		level.Update();
		
		cross1.x = mouseX;
		cross1.y = mouseY;
		cross2.x = (mouseX + player.x) / 2;
		cross2.y = (mouseY + player.y) / 2;
		cross3.x = (mouseX + player.x) / 2;
		cross3.y = (mouseY + player.y) / 2;
		cross3.scaleY = Math.sqrt( Math.pow(mouseX - player.x, 2) + Math.pow(mouseY - player.y, 2)) / 40;
		cross3.rotation = ((180 * Math.atan2(mouseY - player.y, mouseX - player.x)) / Math.PI) + 90;
		cross1.rotation = cross3.rotation + 45;
		crossi.x += (((mouseX + player.x) / 2) - crossi.x) / 20;
		crossi.y += (((mouseY + player.y) / 2) - crossi.y) / 20;
		
		if (level.SwitchedRoom())
		{
			var playerDeltaX = player.x;
			var playerDeltaY = player.y;
			player.x = level.SwitchRoomPlayerPosX();
			player.y = level.SwitchRoomPlayerPosY();
			playerDeltaX -= player.x;
			playerDeltaY -= player.y;
			crossi.x -= playerDeltaX;
			crossi.y -= playerDeltaY;
			
			StoreEntsInRoom(level.previousRoom);
			RemoveAllEnts();
			LoadEntsFromRoom(level.currentRoom);
		}
		MoveCamera();
		MoveWorldToCamera();
		level.UpdateBG();
	}
	
	function RemoveAllEnts() 
	{
		var i = entityList.length - 1;
		while (i >= 1)
		{
			removeChild(entityList[i]);
			entityList.splice(i, 1);
			--i;
		}
		DebugPage.entcount = entityList.length;
		i = enemyList.length - 1;
		while (i >= 0)
		{
			enemyList.splice(i, 1);
			--i;
		}
	}
	
	function StoreEntsInRoom(room:LevelRoom) 
	{
		for (enemy in enemyList)
		{
			room.ents.push(enemy);
		}
		for (item in itemList)
		{
			room.ents.push(item);
		}
	}
	
	function LoadEntsFromRoom(room:LevelRoom) 
	{
		for (ent in room.ents)
		{
			Spawn(ent);
		}
		room.ents = new Array<Entity>();
	}
	
	private function Spawn(newEnt:Entity)
	{
		if (entityList.length < entMax)
		{
			newEntities.push(newEnt);
			addChild(newEnt);
			
			if (Std.is(newEnt, Explosion))
			{
				shake += 12.0;
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
		this.x = (-camera.x * camera.zoom) + Lib.application.window.width / 2;
		this.y = (-camera.y * camera.zoom) + Lib.application.window.height / 2;
		this.scaleX = this.scaleY = camera.zoom * (Lib.application.window.height / 540);
	}
	
	private function MoveCamera() 
	{
		camera.x = (crossi.x + player.x) / 2;
		camera.y = (crossi.y + player.y) / 2;
		
		camera.zoom = Math.max(1 - Math.max(0, ((Math.sqrt( Math.pow(crossi.x - player.x, 2) + Math.pow(crossi.y - player.y, 2)) / 2000)) - 0.1), 0.75);
		camera.x += (Math.random() * shake) - (shake / 2);
		camera.y += (Math.random() * shake) - (shake / 2);
		
		shake *= 0.8;
	}
	
	private function LoadLevels() 
	{
		level = LevelParser.LoadLevel("levels/testlevel1.txt");
		levelDictionary.set("test", level);
		addChildAt(level, 0);
		
		player.x = level.StartRoom().playerSpawnX;
		player.y = level.StartRoom().playerSpawnY;
		
		camera.x = player.x;
		camera.y = player.y;
		crossi.x = player.x;
		crossi.y = player.y;
		
		MoveWorldToCamera();
		level.UpdateBG();
	}
}