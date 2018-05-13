package world;

import openfl.display.Sprite;

/**
 * ...
 * @author Victor Reynolds
 */
class Entity extends Sprite 
{
	public var xv = 0;
	public var yv = 0;
	
	public function new() 
	{
		super();
	}
	
	public function Update()
	{
		x += xv;
		y += yv;
	}
}