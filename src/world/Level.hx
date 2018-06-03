package world;

/**
 * ...
 * @author Victor Reynolds
 */
class Level 
{
	private var xmin:Float;
	private var xmax:Float;
	private var ymin:Float;
	private var ymax:Float;

	public function new() 
	{
		xmin = -400;
		xmax = 400;
		ymin = -240;
		ymax = 240;
	}
	
	public function Collide(ent:Entity)
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