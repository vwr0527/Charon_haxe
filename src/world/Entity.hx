package world;

import openfl.display.Sprite;

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
	public var fric:Float = 0;
	public var rfric:Float = 0;
	
	public function new() 
	{
		super();
	}
	
	public function Update()
	{
		x += xv;
		y += yv;
		rotation += av;
		
		xv *= fric;
		yv *= fric;
		av *= rfric;
	}
}