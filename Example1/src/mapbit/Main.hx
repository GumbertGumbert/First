package mapbit;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Bitmap;
import flash.Lib;
import flash.display.BitmapData;
import openfl.Assets;

/**
 * ...
 * @author VitaL
 */

class Main extends Sprite {

    public function new () {

        super ();

        var bitmapData = Assets.getBitmapData ("img/rain.jpg");
        var bitmap = new Bitmap (bitmapData);
        addChild (bitmap);

        bitmap.x = 100;
        bitmap.y = 200;

    }

}

