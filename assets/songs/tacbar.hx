import funkin.backend.system.Conductor;
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.game.PlayState;
import openfl.display.BitmapData;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.FlxObject;
import flixel.util.FlxAxes;
import openfl.geom.ColorTransform;
import flixel.util.FlxColor;
import sys.FileSystem;
public var triangleFill:FlxSprite;
public var triangle:FlxSprite;
public var ticks:FlxSpriteGroup;
public var SprBorder:FlxSprite;
public var fullBitmap = BitmapData.fromFile(Paths.image('game/tacBarFill'));
public var emptyBitmap = BitmapData.fromFile(Paths.image('game/tacBarEmpty'));
public var currentCorp:Int = 2;
public var tacCam:FlxCamera = new FlxCamera();
var chroma:CustomShader = null;

function create(){
	if(Options.gameplayShaders) {
	
		chroma = new CustomShader('madnesschromaticaberration');
		chroma.intensity = 0.015;
		
		camGame.addShader(chroma);
	}

	for(i=>strumLine in SONG.strumLines){
		for(k=>charName in strumLine.characters){
			if(strumLine.type == 1 && selectedChar!= 'Bf' && !PlayState.isStoryMode){
				remove(boyfriend);
				remove(gf);
				var charPosName:String = strumLine.position == null ? (switch(strumLine.type) {
					case 0: "dad";
					case 1: "boyfriend";
					case 2: "girlfriend";
				}) : strumLine.position;
 
			
				if(PlayState.SONG.meta.name!="manhunt" && PlayState.SONG.meta.name!="apotheosis")
					charName = selectedChar;

				boyfriend = new Character(0, 0, charName, stage.isCharFlipped(charPosName, true));
				stage.applyCharStuff(boyfriend, charPosName, k);

				if(FileSystem.exists("assets/data/scripts/" + charName + "Mechanic.hx"))
				importScript("data/scripts/" + charName + "Mechanic");

				trace(charName);

			}

		}
	}
			
		
			
		
	
}
function onNoteCreation(event) {
	if(FlxG.save.data.middleScroll){
		if (event.note.strumLine == cpuStrums){
			event.note.visible = false;
	
		}
	}
	





}

function onStrumCreation(event) {
	if(FlxG.save.data.middleScroll){
		if (event.player == 1)
			event.strum.x -= 300;
		
		if(event.player == 0||event.player==2){
			event.strum.visible=false;
			//if(event.strumID>1)
				//event.strum.x += 650;
	
			
		}
	}
	




}
function postUpdate(){
	if(!FlxG.save.data.defHealth)
		{
			iconP1.setPosition(1130,530);
			
			iconP1.animation.curAnim.curFrame = currentCorp < 1 ? 1:0;
		}


	if(downscroll)
		iconP1.y = iconP1.y - 550;



}
  function update(){


	if(health <= 0 && canDie)
		updateTicks();
  }
  function onPlayerMiss(e) {
	if(!FlxG.save.data.defHealth)
		if(e.note.noteTypeID == 0) e.healthGain -= 0.08;
  }
function onPlayerHit(e){
	if(!FlxG.save.data.defHealth)
	if(e.note.noteTypeID == 0) e.healthGain = 0;

}
public function updateTicks(){
	switch(ticks.members[currentCorp].animation.curAnim.name){
		case 'Fine':
			ticks.members[currentCorp].animation.play('Hurt');
			health = 0.01;
		
			trace('corp ${currentCorp} status is hurt');
			case 'Hurt':
				ticks.members[currentCorp].animation.play('Burst');
				currentCorp--;
				if(currentCorp>-1){
					health = 2;

					
				}
				else if(currentCorp<0){
					gameOver(boyfriend);
				}		
				trace('corp ${currentCorp} status is Burst');
				
			case 'Burst':
			   
			   


	}
 }
 



function postCreate() {
	
	scoreTxt.font = Paths.font('impact.ttf');
	missesTxt.font = Paths.font('impact.ttf');
	accuracyTxt.font = Paths.font('impact.ttf');

	if(!FlxG.save.data.defHealth){
		tacCam.bgColor = 0;
		FlxG.cameras.add(tacCam, false);

		remove(iconP2);
		remove(iconP1);
 
		remove(healthBar);
		remove(healthBarBG);

		var reference = new FlxObject(0, FlxG.height * 0.9, 601, 19);
		reference.screenCenter(0x01);

		scoreTxt.setPosition(reference.x + 50, reference.y + 30, Std.int(reference.width - 100));
		missesTxt.setPosition(reference.x + 50, reference.y + 30, Std.int(reference.width - 100));
		accuracyTxt.setPosition(reference.x + 50, reference.y + 30, Std.int(reference.width - 100));

		var globalframes = Paths.getFrames('game/NewLifeSystem');

		var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors
		healthBar = new FlxBar(1032,670, FlxBarFillDirection.LEFT_TO_RIGHT,300, 70,this,'health', 0, maxHealth);
		healthBar.createImageBar(emptyBitmap, fullBitmap, FlxColor.RED, FlxColor.BLUE);
		healthBar.scrollFactor.set();

		add(healthBar);


		healthBarBG = new FlxSprite(1032,670).loadGraphic(Paths.image('game/tacBar'));
		healthBarBG.antialiasing = true;
		healthBarBG.scrollFactor.set();

		add(healthBarBG);
		
		//triangles
		triangleFill = new FlxSprite(1160,583);
		triangleFill.loadGraphic(Paths.image('game/triangleFill'));
		triangleFill.scrollFactor.set();

		add(triangleFill);

	

		triangle =new FlxSprite(1160,583);
		triangle.frames = globalframes;
		triangle.animation.addByPrefix('idle', 'IconHolder', 24, true);
		triangle.animation.play('idle');
		triangle.antialiasing = true;
		triangle.scrollFactor.set();

		add(triangle);
		ticks = new FlxSpriteGroup();
		add(ticks);

		for(i in 0...3){
			var tick = new FlxSprite(1044 +(i*35), 624);
			tick.frames = globalframes;
			tick.animation.addByPrefix('Fine', 'CorpusFINE', 24, true);
			tick.animation.addByPrefix('Burst', 'CorpusBURST', 24, false);
			tick.animation.addByPrefix('Hurt', 'CorpusHURT', 24, true);
			tick.cameras = [tacCam];
			tick.scrollFactor.set();

			tick.animation.play('Fine');
			tick.antialiasing = true; 

			ticks.add(tick);
		}
		
		trace(rightColor);
		triangleFill.color = rightColor;

		var red:Int = (rightColor >> 16) & 0xFF;
        var green:Int = (rightColor >> 8) & 0xFF;
        var blue:Int = rightColor & 0xFF;

		var redMultiplier:Float = red / 255.0;
        var greenMultiplier:Float = green / 255.0;
        var blueMultiplier:Float = blue / 255.0;


		var colorTransform = new ColorTransform(redMultiplier, greenMultiplier, blueMultiplier, 1);
		fullBitmap.colorTransform(emptyBitmap.rect, colorTransform);

	
		for(e in [healthBar, healthBarBG,triangleFill,triangle, iconP1, ticks]){
			e.cameras = [tacCam];
			if(downscroll){
				e.y -= 550;

			}
				
				
		}
		
		health = maxHealth;

		add(iconP1);
	}
	

}