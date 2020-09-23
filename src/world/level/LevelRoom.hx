package world.level;
import openfl.display.Bitmap;
import menu.DebugPage;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import world.Camera;
import world.HitShape;
import world.level.LevelTile;
import world.level.DoorController;
import world.level.tiles.DoorTile;
import openfl.Lib;

/**
 * ...
 * @author Victor Reynolds
 */
class LevelRoom extends Sprite
{
	public var xmin:Float;
	public var ymin:Float;
	public var xmax:Float;
	public var ymax:Float;
	
	public var tsize:Float;
	public var xtiles:Int;
	public var ytiles:Int;
	
	public var tiles:Array<Array<LevelTile>>;
	public var triangles:Array<LevelTriangle>;
	public var doors:Array<DoorController>;
	public var ents:Array<Entity>;
	public var bgElements:Array<BackgroundElement>;
	public var fgElements:Array<BackgroundElement>;
	
	public var playerSpawnX:Float;
	public var playerSpawnY:Float;
	
	public var blackTiles:Bitmap;

	public function new(num_x_tiles:Int, num_y_tiles:Int) 
	{
		super();
		tsize = LevelTile.size;
		xmin = 0;
		xmax = num_x_tiles * tsize;
		ymin = 0;
		ymax = num_y_tiles * tsize;
		xtiles = num_x_tiles;
		ytiles = num_y_tiles;
		tiles = new Array<Array<LevelTile>>();
		doors = new Array<DoorController>();
		ents = new Array();
		for (i in 0...num_y_tiles)
		{
			var newRow = new Array();
			tiles.push(newRow);
			for (j in 0...num_x_tiles)
			{
				newRow.push(null);
			}
		}
		triangles = new Array<LevelTriangle>();
		
		bgElements = new Array<BackgroundElement>();
		fgElements = new Array<BackgroundElement>();
	}
	
	public function Update()
	{
		var numtiles:Int = 0;
		
		for (i in 0...ytiles)
		{
			for (j in 0...xtiles)
			{
				if (tiles[i][j] != null)
				{
					tiles[i][j].Update();
					if (tiles[i][j].pic != null && tiles[i][j].visible) ++numtiles;
				}
			}
		}
		DebugPage.tilecount = numtiles;
		
		for (door in doors)
		{
			door.Update();
		}
	}
	
	public function AddTriangle(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float)
	{
		var tri:LevelTriangle = new LevelTriangle(x1, y1, x2, y2, x3, y3);
		triangles.push(tri);
		
		var minxi:Int = GetIndexAtX(tri.hitShape.GetXmin());
		var maxxi:Int = GetIndexAtX(tri.hitShape.GetXmax());
		var minyi:Int = GetIndexAtY(tri.hitShape.GetYmin());
		var maxyi:Int = GetIndexAtY(tri.hitShape.GetYmax());
		for (i in minyi...maxyi + 1)
		{
			for (j in minxi...maxxi + 1)
			{
				var tileX = (j * tsize) + tsize / 2;
				var tileY = (i * tsize) + tsize / 2;
				
				var tileHitbox:HitShape = new HitShape();
				tileHitbox.MakeSquare(tsize);
				
				if (tri.hitShape.TriangleRectOverlap(0,0,tileX,tileY,tileHitbox))
				{
					tiles[i][j] = new LevelTile();
					tiles[i][j].hitShape = tileHitbox;
					tiles[i][j].x = tileX;
					tiles[i][j].y = tileY;
					tiles[i][j].noclip = true;
					tiles[i][j].levelTris.push(tri);
					//tiles[i][j].hitShape.graphic.visible = true;
					//tiles[i][j].addChild(tiles[i][j].hitShape.graphic);
					addChild(tiles[i][j]);
				}
			}
		}
		addChild(tri);
		
		trace("minxi : " + minxi + " maxxi : " + maxxi + " minyi : " + minyi + " maxyi : " + maxyi);
	}
	
	public function SetTile(tile:LevelTile, xi:Int, yi:Int)
	{
		if (tile == null) return;
		if (tiles[yi][xi] != null) removeChild(tiles[yi][xi]);
		tiles[yi][xi] = tile;
		addChild(tile);
		tiles[yi][xi].x = (xi * tsize) + tsize / 2;
		tiles[yi][xi].y = (yi * tsize) + tsize / 2;
	}
	
	public function SetDoor(dtile:DoorTile, xi:Int, yi:Int)
	{
		SetTile(dtile, xi, yi);
		var doorID = dtile.GetID();
		while (doors[doorID] == null) doors.push(new DoorController());
		doors[doorID].doorTiles.push(dtile);
	}
	
	public function GetIndexAtX(xpos:Float):Int
	{
		xpos -= tsize / 2;
		xpos /= tsize;
		return Std.int(Math.min(Math.max(Math.round(xpos), 0), xtiles - 1));
	}
	
	public function GetIndexAtY(ypos:Float):Int
	{
		ypos -= tsize / 2;
		ypos /= tsize;
		return Std.int(Math.min(Math.max(Math.round(ypos), 0), ytiles - 1));
	}
	
	public function SetVisibleTiles(cam:Camera) 
	{
		var camVisW = (Lib.application.window.width / 2) * (1 / (cam.zoom*cam.GetZZoom()));
		var camVisH = (Lib.application.window.height / 2) * (1 / (cam.zoom*cam.GetZZoom()));
		var startx:Int = GetIndexAtX(cam.x - camVisW);
		var starty:Int = GetIndexAtY(cam.y - camVisH);
		var endx:Int = GetIndexAtX(cam.x + camVisW);
		var endy:Int = GetIndexAtY(cam.y + camVisH);
		for (i in 0...ytiles)
		{
			for (j in 0...xtiles)
			{
				if (tiles[i][j] != null)
				{
					if (i >= starty && i <= endy && j >= startx && j <= endx)
					{
						tiles[i][j].visible = true;
					}
					else
					{
						tiles[i][j].visible = false;
					}
				}
			}
		}
	}
	
	public function SetBlackTile(i:Int, j:Int) 
	{
		if (blackTiles == null)
		{
			blackTiles = new Bitmap(new BitmapData(xtiles, ytiles, true, 0x00000000));
			addChildAt(blackTiles, 0);
			blackTiles.x = 0;
			blackTiles.y = 0;
			blackTiles.width = xmax;
			blackTiles.height = ymax;
		}
		
		blackTiles.bitmapData.setPixel32(i, j, 0xFF000000);
	}
	
	public function AddBg(bge)
	{
		bgElements.push(bge);
	}
	public function AddFg(bge)
	{
		fgElements.push(bge);
	}
}
