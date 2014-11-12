package dru;
import flash.display.Sprite;
import flash.Lib;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.text.TextField;
import openfl.events.Event;
import openfl.events.MouseEvent;/**
 * ...
 * @author VitaL
 */
class Tile extends Sprite
{
	public var count:Int = 0;
	public var player:Int = 0;
	public var i:Int = 0;
	public var j:Int = 0;
	public var service:Service;

	public function new(x:Int, y:Int, service:Service) 
	{
		super();
		this.service = service;
		this.i = x;
		this.j = y;
		init();
		this.addEventListener (MouseEvent.MOUSE_DOWN, TileContainer_onMouseDown);
		var bitmapData = Assets.getBitmapData ("img/Tile.png");
        var bitmap = new Bitmap (bitmapData);
        addChild (bitmap);
		var Score = new TextField();
		Score.text = Std.string (count);
		addChild (Score);
	}
	
	private function init() {
		if(player == 0){
		count = Std.random(3); 
		} /* else 
		{
			count = 5;
		}*/
	}
		
	private function TileContainer_onMouseDown (event:MouseEvent):Void {
		if(j>1)
		service.MAP.get(Std.string(i*15+j-1)).chosen();
		if(j<15)
		service.MAP.get(Std.string(i*15+j+1)).chosen();
		if(i>1)
		service.MAP.get(Std.string((i-1)*15+j)).chosen();
		if(i<15)
		service.MAP.get(Std.string((i+1)*15+j)).chosen();
        chosen();
	}
	
	public function chosen() {
		
        var square = new Sprite();
        square.graphics.lineStyle(2, 0xFF0000);
        square.graphics.beginFill(0x0000FF, 0.1);
        square.graphics.drawRect(0, 0, 100, 100);
		addChild(square);
		}
}