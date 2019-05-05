package;
import openfl.display.Sprite;

/**
 * ...
 * @author 
 */
class Crosshair extends Sprite
{
	var sprite:Sprite;
	
	public function new() 
	{
		super();
	}
	
	public function CreatePrimaryCrosshair()
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
		addChild(sprite);
	}
	
	public function CreateSecondaryCrosshair()
	{
		sprite = new Sprite();
		sprite.graphics.lineStyle(1, 0x00FF00);
		
		var a = 2;
		
		sprite.graphics.moveTo( -a, 0);
		sprite.graphics.lineTo( 0, -a);
		sprite.graphics.lineTo( a, 0);
		sprite.graphics.lineTo( 0, a);
		sprite.graphics.lineTo( -a, 0);
		addChild(sprite);
	}
	
	public function CreateTertiaryCrosshair()
	{
		sprite = new Sprite();
		sprite.graphics.lineStyle(2, 0x00FF00, 0.1);
		
		sprite.graphics.moveTo( 0, -8);
		sprite.graphics.lineTo( 0, -12);
		addChild(sprite);
	}
}