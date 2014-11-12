package ;
import openfl.display.CapsStyle;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.Sprite;

/**
 * ...
 * @author VitaL
 */
class Shell extends Sprite
{

	public function new() 
	{
		super();
		this.graphics.lineStyle(1, 0x000000, 1.0, true, LineScaleMode.NORMAL,CapsStyle.SQUARE,JointStyle.MITER, 1.0);
		this.graphics.lineTo(0, 499);
		this.graphics.lineTo(499, 499);
		this.graphics.lineTo(499, 0);
		this.graphics.lineTo(0, 0);
		this.graphics.endFill();
	}
	
}