package ;
import openfl.display.Sprite;

/**
 * ...
 * @author VitaL
 */
class Enemy extends Sprite
{

	public var row:Int;
	public var distance:Float;
	public var direction:Int;
	public function new() 
	{
		super();
		this.graphics.beginFill(0x696969);
		this.graphics.drawRect(0, 0, 40, 25);
		this.graphics.drawRect(15, 25, 10, 8);
		this.graphics.endFill();
	}
	public function killZone(x:Float, y:Float):Bool
	{
		if (((this.x<(x+10))&&((this.x+40)>x))&&(((this.y+25)>y)&&(this.y<(y+6))))
		return true;
		else return false;
	}
}