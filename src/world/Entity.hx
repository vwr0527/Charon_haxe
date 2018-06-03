package world;

import openfl.display.Sprite;
import openfl.utils.Function;

/**
 * ...
 * @author Victor Reynolds
 */
class Entity extends Sprite 
{
	public var active:Bool = true;
	public var xv:Float = 0;
	public var yv:Float = 0;
	public var av:Float = 0;
	public var tf:Float = 0;
	public var rf:Float = 0;
	private var t:Float = 0;
	
	public function new() 
	{
		super();
	}
	
	public function Update(Spawn:Function)
	{
		t = Math.max(Math.min(60 / Main.getFPS(), 2), 0.25);
		
		x += xv * t;
		y += yv * t;
		rotation += av * t;
		
		xv *= 1 / Math.pow(10, tf * t);
		yv *= 1 / Math.pow(10, tf * t);
		av *= 1 / Math.pow(10, rf * t);
	}
}