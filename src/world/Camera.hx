package world;

/**
 * ...
 * @author Victor Reynolds
 */
class Camera 
{
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var zoom:Float;

	public function new() 
	{
		x = 0;
		y = 0;
		z = 0;
		zoom = 1;
	}
	
	public function GetZZoom():Float
	{
		if (z >= 1.0)
		{
			return 100 / z;
		}
		else
		{
			return 1.0;
		}
	}
}