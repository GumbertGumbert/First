package ;
import openfl.display.Sprite;

/**
 * ...
 * @author VitaL
 */
class Shot extends Sprite
{

	public function new() 
	{
		super();
		this.graphics.beginFill(0xffd700);
		this.graphics.drawRect(0, 0, 1, 3);
		this.graphics.endFill();
	}
	
}