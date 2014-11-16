package ;
import openfl.display.Sprite;

/**
 * ...
 * @author VitaL
 */
class Player extends Sprite
{
	public function new() 
	{
		super();
		this.graphics.beginFill(0x2f4f4f);
		this.graphics.drawRect(0, 0, 50, 25);
		this.graphics.drawRect(20, 0, 10, -10);
		this.graphics.endFill();
	}
		public function killZone(x:Float, y:Float):Bool
	{
		if (((this.x<(x+10))&&((this.x+50)>x))&&(((this.y+25)>y)&&(this.y<(y+6))))
		return true;
		else return false;
	}
}