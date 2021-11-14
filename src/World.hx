package;

import menu.DebugPage;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.ui.Mouse;
import util.LevelEditor;
import world.Camera;
import world.Enemy;
import world.Entity;
import world.Explosion;
import world.level.Level;
import world.level.LevelRoom;
import world.Shot;
import world.Player;

/**
 * ...
 * @author Victor Reynolds
 */
class World extends Sprite 
{
	private var frameCounter:Float = 0;
	private var paused:Bool;
	private var camera:Camera;
	private var player:Player;
	private var entityList:Array<Entity>;
	private var playerShots:Array<Shot>;
	private var enemyShots:Array<Shot>;
	private var enemyList:Array<Enemy>;
	private var itemList:Array<Entity>;
	private var newEntities:Array<Entity>;
	private var levelDictionary:Map<String, Level>;
	private var level:Level;
	private var levelEditor:LevelEditor;
	
	private var shipLayer:Sprite;
	private var shotLayer:Sprite;
	private var levelLayer:Sprite;
	private var backgroundLayer:Sprite;
	private var foregroundLayer:Sprite;
	
	private var cross:Crosshair;
	private var follow_x:Float;
	private var follow_y:Float;
	private var blinder_left:Sprite;
	private var blinder_right:Sprite;
	private var blinder_up:Sprite;
	private var blinder_down:Sprite;
	
	private var entMax = 4000;
	
	public static var shake:Float = 0.0;
	
	public function new() 
	{
		super();
		
		entityList = new Array();
		newEntities = new Array();
		
		playerShots = new Array();
		enemyShots = new Array();
		enemyList = new Array();
		itemList = new Array();
		
		shipLayer = new Sprite();
		shotLayer = new Sprite();
		levelLayer = new Sprite();
		backgroundLayer = new Sprite();
		foregroundLayer = new Sprite();
		
		addChild(backgroundLayer);
		addChild(levelLayer);
		addChild(shotLayer);
		addChild(shipLayer);
		addChild(foregroundLayer);
		
		player = new Player();
		entityList.push(player);
		shipLayer.addChild(player);
		
		camera = new Camera();
		
		CreateCrosshairs();
		
		levelEditor = new LevelEditor();
		levelDictionary = new Map();
		LoadLevels();
		
		LoadEntsFromRoom(level.currentRoom);
		
		MoveCamera();
		MoveWorldToCamera();
		level.UpdateDisplay(camera);
	}
	
	public function GetLevelEditor():LevelEditor
	{
		return levelEditor;
	}
	
	public function Update()
	{
		if (paused) return;
		
		if (LevelEditor.active)
		{
			levelEditor.Update(camera);
			MoveWorldToCamera();
			level.UpdateDisplay(camera);
			return;
		}
		
		frameCounter += 1;
		
		player.LookAt(mouseX, mouseY);
		
		// Update all Ents, Ents collide with Level
		for (ent in entityList)
		{
			ent.Update(Spawn);
			ent.LevelCollide(level);
		}
		
		// Check to see if enemy's shots hit player
		for (eshot in enemyShots)
		{
			if (!eshot.AlreadyHit()) player.CheckShotHit(eshot);
		}
		
		// Update Enemy AI and check if player's shot hit enemy
		for (enemy in enemyList)
		{
			enemy.LookAt(player.x, player.y);
			for (shot in playerShots)
			{
				if (!shot.AlreadyHit()) enemy.CheckShotHit(shot);
			}
		}
		
		// Spawn new Ents, and put them in the right list
		for (ent in newEntities)
		{
			if (Std.is(ent, Enemy))
			{
				enemyList.push(cast(ent, Enemy));
			}
			else if (Std.is(ent, Shot))
			{
				var shot:Shot = cast(ent, Shot);
				if (shot.isPlayerShot)
				{
					playerShots.push(shot);
				}
				else
				{
					enemyShots.push(shot);
				}
			}
			entityList.push(ent);
		}
		newEntities = new Array();
		
		// Delete inactive Ents from Entity List
		var i = entityList.length - 1;
		while (i >= 0)
		{
			if (entityList[i].active == false)
			{
				if (Std.is(entityList[i], Shot))
				{
					shotLayer.removeChild(entityList[i]);
				} else 
				{
					shipLayer.removeChild(entityList[i]);
				}
				
				entityList.splice(i, 1);
			}
			--i;
		}
		DebugPage.entcount = entityList.length;
		
		// Delete inactive Enemies from Enemy list
		i = enemyList.length - 1;
		while (i >= 0)
		{
			if (enemyList[i].active == false)
			{
				enemyList.splice(i, 1);
			}
			--i;
		}
		
		// Delete inactive Player's Shots from playerShot list
		i = playerShots.length - 1;
		while (i >= 0)
		{
			if (playerShots[i].active == false)
			{
				playerShots.splice(i, 1);
			}
			--i;
		}
		
		// Delete inactive Enemy's Shots from enemyShot list
		i = enemyShots.length - 1;
		while (i >= 0)
		{
			if (enemyShots[i].active == false)
			{
				enemyShots.splice(i, 1);
			}
			--i;
		}
		
		level.Update();
		
		UpdateCrosshairs();
		
		if (level.SwitchedRoom())
		{
			SwitchRoom();
		}
		
		MoveCamera();
		MoveWorldToCamera();
		level.UpdateDisplay(camera);
	}
	
	function RemoveAllEnts() 
	{
		var i = entityList.length - 1;
		while (i >= 1)
		{
			if (Std.is(entityList[i], Shot))
			{
				shotLayer.removeChild(entityList[i]);
			} else 
			{
				shipLayer.removeChild(entityList[i]);
			}
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
		i = playerShots.length - 1;
		while (i >= 0)
		{
			playerShots.splice(i, 1);
			--i;
		}
		i = enemyShots.length - 1;
		while (i >= 0)
		{
			enemyShots.splice(i, 1);
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
		if ((entityList.length + newEntities.length) < entMax)
		{
			newEntities.push(newEnt);
			
			if (Std.is(newEnt, Shot))
			{
				shotLayer.addChild(newEnt);
			}
			else
			{
				shipLayer.addChild(newEnt);
			}
			
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
		var zzoom = camera.GetZZoom();
		this.x = (-camera.x * camera.zoom * zzoom) + Lib.application.window.width / 2;
		this.y = (-camera.y * camera.zoom * zzoom) + Lib.application.window.height / 2;
		this.scaleX = this.scaleY = camera.zoom * zzoom * (Lib.application.window.height / 540);
		levelLayer.visible = shipLayer.visible = shotLayer.visible = cross.visible = (camera.z >= 1.0);
	}
	
	private function MoveCamera() 
	{
		camera.x = (follow_x + player.x) / 2;
		camera.y = (follow_y + player.y) / 2;
		
		camera.z = 100 + (100 * (1 - Math.max(1 - Math.max(0, (Math.sqrt( Math.pow(follow_x - player.x, 2) + Math.pow((follow_y - player.y) * 1.778, 2)) / 2000) - 0.075), 0.75)));
		
		if (camera.z < 1) camera.z = 1;
		camera.zoom = Math.max(1 - Math.max(0, ((Math.sqrt( Math.pow(follow_x - player.x, 2) + Math.pow((follow_y - player.y) * 1.778, 2)) / 4000)) - 0.075), 0.75);
		camera.x += (Math.random() * shake) - (shake / 2);
		camera.y += (Math.random() * shake) - (shake / 2);
		
		//DebugPage.Log(" " + Lib.application.window.width);
		
		shake *= 0.8;
	}
	
	private function LoadLevels() 
	{
		levelEditor.ReadLevel("levels/testlevel1.json");
		trace(levelEditor.OutputString());
		level = levelEditor.BuildLevel(backgroundLayer, foregroundLayer);
		levelDictionary.set("test", level);
		levelLayer.addChild(level);
		
		player.x = level.StartRoom().playerSpawnX;
		player.y = level.StartRoom().playerSpawnY;
		
		camera.x = player.x;
		camera.y = player.y;
		follow_x = player.x;
		follow_y = player.y;
		
		MoveWorldToCamera();
		level.UpdateDisplay(camera);
	}
	
	private function SwitchRoom()
	{
		var playerDeltaX = player.x;
		var playerDeltaY = player.y;
		player.x = level.SwitchRoomPlayerPosX();
		player.y = level.SwitchRoomPlayerPosY();
		playerDeltaX -= player.x;
		playerDeltaY -= player.y;
		follow_x -= playerDeltaX;
		follow_y -= playerDeltaY;
		
		level.BgSwitchRoom(playerDeltaX, playerDeltaY);
		
		StoreEntsInRoom(level.previousRoom);
		RemoveAllEnts();
		LoadEntsFromRoom(level.currentRoom);
	}
	
	private function CreateCrosshairs()
	{
		cross = new Crosshair();
		addChild(cross);
	}
	
	private function UpdateCrosshairs() 
	{
		cross.UpdateCrosshair(player.x, player.y, mouseX, mouseY);
		
		follow_x += (((mouseX + player.x) / 2) - follow_x) / 20;
		follow_y += (((mouseY + player.y) / 2) - follow_y) / 20;
	}
}