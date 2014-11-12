package dru;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import openfl.display.Bitmap;
import openfl.Assets;
import haxe.ds.HashMap;

/**
 * ...
 * @author VitaL
 */
class Game extends Sprite 
{
	var service:Service;
	public function new() 
	{
		super();
		service = new Service();
		//service.MAP.push(1);
		map(3, 3);
	}
	
	private function map(w:Int, h:Int) {
		for (i in 0...w ) {
			for (j in 0...h ) {
				var tile = new Tile(i, j, service);
				tile.x = i * 100;
				tile.y = j * 100;
				
				service.MAP.set(Std.string(i*15+j), tile);
				addChild(tile);
			}
		}
	}
	/*private var Background:Bitmap;
	private var Game:Main;

	public function new() 
	{
		
		super ();
		
		initialize ();
		construct ();
	}
	private function construct ():Void 
	{
		addChild (Background);
		addChild (Game);
	}
		private function initialize ():Void 
		{
		Background = new Bitmap (Assets.getBitmapData ("img/rain.jpg"));
		//Footer = new Bitmap (Assets.getBitmapData ("images/center_bottom.png"));
		Game = new Main ();
		}
		*/
		
}