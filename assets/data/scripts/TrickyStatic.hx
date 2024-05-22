
public var spookyText:FlxText;
 public var tstatic:FlxSprite;
 public var spookySteps:Int = 0;
 public  var spookyRendered:Bool = false;
 public  var resetSpookyText:Bool = true;
 public var tLines:Array<String> = ["DIE","HAHAHA", "ERROR", "FUCK YOU", "KILL", "STUPID", "CLOWN", "MAD", "ERROR", "ADJUSTING", "IMPROBABLE", "HEYYYY", "MISJUDGED"];

 function postUpdate(elapsed){
	if (spookyRendered) // move shit around all spooky like
		{
			spookyText.angle = FlxG.random.int(-5,5); // change its angle between -5 and 5 so it starts shaking violently.
			tstatic.x = tstatic.x + FlxG.random.int(-2,2); // move it back and fourth to repersent shaking.
			
			tstatic.alpha = FlxG.random.float(0.1,0.5); // change le alpha too :)
		}

  }
  function onDadHit(e){
	if (FlxG.random.bool(30) && !spookyRendered && !e.note.mustPress && e.character == dad) // create spooky text :flushed:
		{
	
			createSpookyText(tLines[FlxG.random.int(0,tLines.length)], dad.x - dad.width/2 + FlxG.random.float(-50, 800), dad.y /2 + FlxG.random.float(-50, 800));
		}
  }
function postCreate(){

		spookyText = new FlxText(0,0);

		spookyText.setFormat("Impact", 80, 0xFF0000);
		
		spookyText.bold = true;
		add(spookyText);
		spookyText.kill();
		tstatic = new FlxSprite(0,0).loadGraphic(Paths.image('game/TrickyStatic'), true, 320, 180);
		tstatic.antialiasing = true;
		tstatic.scrollFactor.set(0,0);
		tstatic.setGraphicSize(Std.int(tstatic.width * 7));
		tstatic.screenCenter();
		tstatic.animation.add('static', [0, 1, 2], 24, true);
		tstatic.animation.play('static');
		tstatic.alpha = 0.5;

		tstatic.cameras = [camHUD];
		add(tstatic);
		tstatic.kill();

	
	
}
function stepHit(curStep){
	
	if (spookyRendered && spookySteps + 3 < curStep)
		{
		
				spookyText.kill();

				spookyRendered = false;
		
				tstatic.kill();


		
		}
}
public function createSpookyText(text:String, x:Float = -1111111111111, y:Float = -1111111111111):Void
	{
		spookySteps = Conductor.curStep;
		spookyRendered = true;
		spookyText.setPosition(x == -1111111111111 ? FlxG.random.float(dad.x - 100,dad.x + 20) : x, y == -1111111111111 ? FlxG.random.float(dad.y + 200, dad.y + 300) : y);
		spookyText.text = text;

		tstatic.revive();
		spookyText.revive();

		FlxG.sound.play(Paths.sound('staticSound'));

		
	}