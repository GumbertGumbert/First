package ;
import openfl.display.Sprite;

/**
 * ...
 * @author VitaL
 */
class Enemy extends Sprite
{

	public function new() 
	{
		super();
		this.graphics.beginFill(0x696969);
		this.graphics.drawRect(0, 0, 45, 25);
		this.graphics.endFill();
	}
	
}