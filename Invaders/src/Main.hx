package ;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
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
	private var playerSpeed:Int;
	private var enemySpeed:Float;
	private var shotSpeed:Int;
	private var scorePlayer:Int;
	private var arrowKeyLeft:Bool;
	private var arrowKeyRight:Bool;
	private var arrowKeySpace:Bool;
	private var shell:Shell;
	private var shotTimer:Timer;
	private var enemyShotTimer:Timer;
	private var enemyShot:Int;
	private var shotStop:Bool;
	private var scoreField:TextField;
	private var messageField:TextField;
	private var endField:TextField;
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
		enemyAmount = 40;
		playerSpeed = 10;
		enemySpeed = 10/60;
		shotSpeed = 12;
		shotStop = true;
		
		shell = new Shell ();
		shell.x = 0;
		shell.y = 0;
		this.addChild(shell);
		player = new Player();
		this.addChild(player);
		shotTimer = new Timer(500);
		enemyShotTimer = new Timer(700);
		enemy = new Vector <Enemy>();
		shot = new Vector <Shot>();
		var scoreFormat:TextFormat = new TextFormat("Verdana", 25, 0x000000, true);
		scoreFormat.align = TextFormatAlign.RIGHT;

		scoreField = new TextField();
		addChild(scoreField);
		scoreField.width = 500;
		scoreField.y = 0;
		scoreField.defaultTextFormat = scoreFormat;
		scoreField.selectable = false;
		
		var messageFormat:TextFormat = new TextFormat("Verdana", 18, 0x000000, true);
		messageFormat.align = TextFormatAlign.CENTER;

		messageField = new TextField();
		addChild(messageField);
		messageField.width = 500;
		messageField.y = 315;
		messageField.defaultTextFormat = messageFormat;
		messageField.selectable = false;
		messageField.text = "Press ENTER to start\nUse ARROW KEYS to move your spaceship,\nSPACE to shoot";
		setGameState(Paused);
		
		var endFormat:TextFormat = new TextFormat("Verdana", 30, 0x000000, true);
		endFormat.align = TextFormatAlign.CENTER;

		endField = new TextField();
		addChild(endField);
		endField.width = 500;
		endField.y = 230;
		endField.defaultTextFormat = endFormat;
		endField.selectable = false;
		endField.alpha = 0;
		
		enemyShotTimer.start();
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		shotTimer.addEventListener(TimerEvent.TIMER, checkTimer);
		enemyShotTimer.addEventListener(TimerEvent.TIMER, checkEnemyTimer);
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
			endField.alpha = 0;
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
				player.x = 225;
				player.y = 460;
				var i:Int;
				for (i in 0...(enemyAmount))
				{
					tempEnemy = new Enemy();
					tempEnemy.row = Math.floor(i / 8);
					tempEnemy.direction = 1;
					tempEnemy.x = 10+20*(i%8) + 40 * (i%8);
					tempEnemy.y = 40 + 15 * (tempEnemy.row) + 25 * tempEnemy.row;
					tempEnemy.distance = tempEnemy.x;
					enemy.push(tempEnemy);
					this.addChild(enemy[enemy.length-1]);
				}
				enemyShot = -1;
			}else {
				messageField.alpha = 0;
			}
	}
	
	private function everyFrame(event:Event):Void {
		if (currentGameState == Playing) {
			endField.alpha = 0;
			//  movement
			if (arrowKeyLeft) {
				player.x -= playerSpeed;
			}
			if (arrowKeyRight) {
				player.x += playerSpeed;
			}
			var j:Int;
			//enemy movement
			if (enemyShot != -1)
			{
				shoot((enemy[enemyShot].x + 15), (enemy[enemyShot].y + 33), 1, true);
				enemyShot = -1;
			}
			for (j in 0...enemy.length)
			{
				enemy[j].y += enemySpeed;
				enemy[j].x = enemy[j].x + enemySpeed * enemy[j].direction;
				if (enemy[j].x >= (enemy[j].distance+20)) {
				enemy[j].x = enemy[j].distance + 20;
				enemy[j].direction *= -1;
				}
				if (enemy[j].x <= (enemy[j].distance)) {
					enemy[j].x = enemy[j].distance;
					enemy[j].direction *= -1;
				}
				if ((enemy[j].y + 33)>= 500)
				endGame(false);
			}
			// player platform limits
			if (player.x < 5) player.x = 5;
			if (player.x > 445) player.x = 445;
			if ((arrowKeySpace)&&(shotStop)) {
				shoot((player.x + 20), (player.y - 16), -1, false);
				shotStop = false;
				shotTimer.start();
			}
			j=0;
			while (j  < shot.length)
			{
				shot[j].y = shot[j].y + shotSpeed * shot[j].direction;
				j++;
			}
			j = 0;
			while (j < shot.length)
			{
				if ((shot[j].y > 500) || (shot[j].y < 0))
				{
					this.removeChild(shot[j]);
					shot.splice(j, 1);
					j--;
				}
				j++;
			}
			var i:Int = 0;
			j = enemy.length-1;
			while (i<shot.length)
			{
				if (!shot[i].friendly)
				{
					while (j>=0)
					{
						if ((enemy[j].killZone(shot[i].x, shot[i].y))&&(!shot[i].friendly))
						{
							scorePlayer++;
							updateScore();
							this.removeChild(enemy[j]);
							this.removeChild(shot[i]);
							shot.splice(i, 1);
							enemy.splice(j, 1);
							i--;
							j--;
							break;
						}
						j--;
					}
				}
				else if ((player.killZone(shot[i].x, shot[i].y)) && (shot[i].friendly)) {
					endGame(false);
				}
				i++;
			}
			if (enemy.length == 0)
			endGame(true);
		}
	}
	private function endGame(result:Bool):Void {
		var k:Int=0;
		while (k < enemy.length)
		{
			this.removeChild(enemy[enemy.length-1]);
			enemy.pop();
		}
		while (k < shot.length)
		{
			this.removeChild(shot[shot.length-1]);
			shot.pop();
		}
		setGameState(Paused);
		if (!result) {
		endField.text = "You lose!\nYou get " + scorePlayer + "000 scores!";
		} else
		{
		endField.text = "You win!\nYou get " + scorePlayer + "000 scores!";
		}
		endField.alpha = 1;
		scorePlayer = 0;
	}
	private function checkTimer(event:TimerEvent):Void {
			shotStop = shotTimer.running;
			shotTimer.reset();
	}
	private function checkEnemyTimer(event:TimerEvent):Void {
		
		if (enemy.length!=0)
		enemyShot = (Math.floor(Math.random() / (1/enemy.length)));
		enemyShotTimer.reset();
		enemyShotTimer.start();
	}
	private function shoot(x:Float, y:Float, direction:Int, friendly:Bool):Void {
		var tempShot:Shot;
		tempShot = new Shot();
		tempShot.x = x;
		tempShot.y = y;
		tempShot.direction = direction;
		tempShot.friendly = friendly;
		shot.push(tempShot);
		this.addChild(shot[shot.length-1]);
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
