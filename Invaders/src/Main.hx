package ;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Vector;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

/**
 * ...
 * @author VitaL
 */

enum GameState {
	Paused;
	Playing;
}

class Main extends Sprite 
{
	var inited:Bool;
	private var player:Player;
	private var enemyAmount:Int;
	private var enemy:Vector<Enemy>;
	private var shot:Vector<Shot>;
	private	var tempEnemy:Enemy;
	private var currentGameState:GameState;
	private var playerSpeed: Int;
	private var enemySpeed: Int;
	private var scorePlayer: Int;
	private var arrowKeyLeft:Bool;
	private var arrowKeyRight:Bool;
	private var arrowKeySpace:Bool;
	private var shell:Shell;
	private var scoreField:TextField;
	private var messageField:TextField;
	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		scorePlayer = 0;
		enemyAmount = 9;
		playerSpeed = 7;
		
		shell = new Shell ();
		shell.x = 0;
		shell.y = 0;
		this.addChild(shell);
		player = new Player();
		player.x = 250;
		player.y = 460;
		this.addChild(player);
		enemy = new Vector <Enemy>();
		var i:Int;
		for (i in 0...(enemyAmount-1))
		{
			tempEnemy = new Enemy();
			tempEnemy.x = 15*(i+1) + 45 * i;
			tempEnemy.y = 40;
			enemy.push(tempEnemy);
			this.addChild(enemy[enemy.length-1]);
		}
		var scoreFormat:TextFormat = new TextFormat("Verdana", 25, 0x000000, true);
		scoreFormat.align = TextFormatAlign.RIGHT;

		scoreField = new TextField();
		addChild(scoreField);
		scoreField.width = 500;
		scoreField.y = 10;
		scoreField.defaultTextFormat = scoreFormat;
		scoreField.selectable = false;
		
		var messageFormat:TextFormat = new TextFormat("Verdana", 18, 0x000000, true);
		messageFormat.align = TextFormatAlign.CENTER;

		messageField = new TextField();
		addChild(messageField);
		messageField.width = 500;
		messageField.y = 250;
		messageField.defaultTextFormat = messageFormat;
		messageField.selectable = false;
		messageField.text = "Press ENTER to start\nUse ARROW KEYS to move your spaceship,\nSPACE to shoot";
		setGameState(Paused);
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		this.addEventListener(Event.ENTER_FRAME, everyFrame);
		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
	}

	/* SETUP */
	
	private function keyDown(event:KeyboardEvent):Void {
		if (currentGameState == Paused && event.keyCode == 13) { // Enter
			setGameState(Playing);
		}else if (event.keyCode == 37) { // Left
			arrowKeyLeft = true;
		}else if (event.keyCode == 39) { // Right
			arrowKeyRight = true;
		}else if (event.keyCode == 32) {
			arrowKeySpace = true;
		}
	}
	private function keyUp(event:KeyboardEvent):Void {
		if (event.keyCode == 37) { // Left
			arrowKeyLeft = false;
		}else if (event.keyCode == 39) { // Right
			arrowKeyRight = false;
		}else if (event.keyCode == 32) {
			arrowKeySpace = false;
		}
	}
	
	private function updateScore (): Void {
		scoreField.text = scorePlayer+"000";
	}
	private function setGameState(state:GameState):Void {
		currentGameState = state;
		updateScore();
			if (state == Paused) {
				messageField.alpha = 1;
			}else {
				messageField.alpha = 0;
			}
	}
	
	private function everyFrame(event:Event):Void {
		if (currentGameState == Playing) {
			//  movement
			if (arrowKeyLeft) {
				player.x -= playerSpeed;
			}
			if (arrowKeyRight) {
				player.x += playerSpeed;
			}
			// player platform limits
			if (player.x < 5) player.x = 5;
			if (player.x > 445) player.x = 445;
		}
	}
	
	private function shoot(x:Int, y:Int, direction:Int):Void {
		var tempShot:Shot;
		tempShot = new Shot();
		tempShot.x = x;
		tempShot.y = y;
		shot.push(tempShot);
		this.addChild(enemy[enemy.length-1]);
	}
	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
