package ;
import openfl.display.Sprite;

/**
 * ...
 * @author VitaL
 */
class Shot extends Sprite
{
	public var direction:Int;
	public var friendly:Bool;
	public function new() 
	{
		super();
		this.graphics.beginFill(0xff4500);
		this.graphics.drawRect(0, 0, 10, 6);
		this.graphics.endFill();
	}
	
}