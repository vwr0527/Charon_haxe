package;
import openfl.display.Sprite;

/**
 * ...
 * @author 
 */
class Crosshair extends Sprite
{
	var sprite:Sprite;
	var cross1:Sprite;
	var cross2:Sprite;
	var cross3:Sprite;
	
	public function new() 
	{
		super();
		cross1 = CreatePrimaryCrosshair();
		addChild(cross1);
		
		cross2 = CreateSecondaryCrosshair();
		addChild(cross2);
		
		cross3 = CreateTertiaryCrosshair();
		addChild(cross3);
	}
	
	public function UpdateCrosshair(sx:Float, sy:Float, ex:Float, ey:Float)
	{
		cross1.x = ex;
		cross1.y = ey;
		cross2.x = (ex + sx) / 2;
		cross2.y = (ey + sy) / 2;
		cross3.x = (ex + sx) / 2;
		cross3.y = (ey + sy) / 2;
		cross3.scaleY = Math.sqrt( Math.pow(ex - sx, 2) + Math.pow(ey - sy, 2)) / 40;
		cross3.rotation = ((180 * Math.atan2(ey - sy, ex - sx)) / Math.PI) + 90;
		cross1.rotation = cross3.rotation + 45;
	}
	
	private function CreatePrimaryCrosshair():Sprite
	{
		sprite = new Sprite();
		sprite.graphics.lineStyle(2, 0x00FF00);
		
		var a = 7;
		var b = 3;
		
		sprite.graphics.moveTo( -a, -a);
		sprite.graphics.lineTo( -b, -b);
		sprite.graphics.moveTo( a, -a);
		sprite.graphics.lineTo( b, -b);
		sprite.graphics.moveTo( a, a);
		sprite.graphics.lineTo( b, b);
		sprite.graphics.moveTo( -a, a);
		sprite.graphics.lineTo( -b, b);
		return sprite;
	}
	
	private function CreateSecondaryCrosshair():Sprite
	{
		sprite = new Sprite();
		sprite.graphics.lineStyle(1, 0x00FF00);
		
		var a = 2;
		
		sprite.graphics.moveTo( -a, 0);
		sprite.graphics.lineTo( 0, -a);
		sprite.graphics.lineTo( a, 0);
		sprite.graphics.lineTo( 0, a);
		sprite.graphics.lineTo( -a, 0);
		return sprite;
	}
	
	private function CreateTertiaryCrosshair():Sprite
	{
		sprite = new Sprite();
		sprite.graphics.lineStyle(2, 0x00FF00, 0.1);
		
		sprite.graphics.moveTo( 0, -8);
		sprite.graphics.lineTo( 0, -12);
		return sprite;
	}
}