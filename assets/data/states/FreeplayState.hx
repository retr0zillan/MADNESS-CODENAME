
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import funkin.backend.scripting.ModState;
import lime.app.Promise;
import flixel.FlxObject;
import funkin.backend.shaders.CustomShader;
import haxe.Json;
import funkin.backend.FunkinText;
import funkin.menus.credits.CreditsMain;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.backend.MusicBeatState;
import flixel.util.FlxColor;
import lime.app.Application;
import openfl.events.Event;
import funkin.options.OptionsMenu;
import hxvlc.flixel.FlxVideoSprite;
import flixel.util.FlxTimer;
import openfl.system.System;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;
import openfl.net.FileFilter;
import flixel.util.FlxAxes;
import funkin.editors.EditorPicker;
import flixel.math.FlxRect;
import funkin.menus.FreeplayState.FreeplaySonglist;
import flixel.group.FlxSpriteGroup;
import haxe.xml.Access;
import haxe.xml.Parser;
import Xml;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText.FlxTextAlign;
import flixel.math.FlxMath;
import haxe.Json;
import funkin.backend.chart.Chart;
import flixel.FlxCamera;
import funkin.savedata.FunkinSave;
import funkin.backend.scripting.events.EventGameEvent;
import funkin.backend.scripting.events.FreeplaySongSelectEvent;
import funkin.backend.scripting.events.MenuChangeEvent;
import funkin.backend.scripting.EventManager;
import lime.graphics.Image;
import flixel.addons.transition.FlxTransitionableState;

import lime.app.Event;
import lime.app.Future;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import funkin.backend.MusicBeatState;

public var songs:Array<ChartMetaData> = [];
public var curSelected:Int = 0;
public var scoreText:FlxText;
public var diffText:FlxText;
public var lerpScore:Int = 0;
public var intendedScore:Int = 0;
public var songList:FreeplaySonglist;
public var curDifficulty:Int = 1;

public var disableAsyncLoading:Bool = #if desktop false #else true #end;
 var camHUD:FlxCamera;
 var camGame:FlxCamera;
 var glitch:CustomShader;
  var future:Future<BitmapData>;

function create(){

	FlxG.mouse.visible = true;
	CoolUtil.playMenuSong();
		songList = FreeplaySonglist.get();
		songs = songList.songs;

		for(k=>s in songs) {
			if (s.name == Options.freeplayLastSong) {
				curSelected = k;
			}
		}
		if (songs[curSelected] != null) {
			for(k=>diff in songs[curSelected].difficulties) {
				if (diff == Options.freeplayLastDifficulty) {
					curDifficulty = k;
				}
			}
		}


}
var coolBg:FunkinSprite;
var box:FunkinSprite;
public var selectSqr:FunkinSprite;
var cuteRect:FlxRect;
var framee:FunkinSprite;
public var separation:Float;
public var songsGroup:FlxSpriteGroup;
public var totalHeight:Float = 0;
var diffSelectors:FlxSpriteGroup;
var bars:FunkinSprite;
var kawaiiRect:FlxRect;
var locks:FlxSpriteGroup;
var originsMap:Map<String, Array<String>>=[];
function postCreate(){


	glitch = new CustomShader('glitchShader1');

   coolBg=new FunkinSprite(0,0);
   coolBg.antialiasing = true;
   coolBg.shader = glitch;
   add(coolBg);

   box = new FunkinSprite(46, 92);
   box.antialiasing=true;
   box.frames = Paths.getFrames('menus/freeplay/FreeplayStuff');
   box.animation.addByPrefix('idle', 'FreeplayBox', 24);
   box.animation.play('idle');
   box.scale.set(0.7,0.7);
   
   add(box);

   selectSqr = new FunkinSprite(100, 92);
    
   selectSqr.frames = Paths.getFrames('menus/freeplay/FreeplayStuff');
   selectSqr.animation.addByPrefix('idle', 'SelectBox1_idle', 24, true);
   selectSqr.animation.addByPrefix('moves', 'SelectBox1_move', 24, false);
   selectSqr.animation.play('idle');
   selectSqr.antialiasing=true;
   selectSqr.scale.set(0.7,0.7);
   selectSqr.updateHitbox();


   add(selectSqr);


   framee = new FunkinSprite(46, 92);
   framee.antialiasing=true;
   framee.frames = Paths.getFrames('menus/freeplay/FreeplayStuff');
   framee.animation.addByPrefix('idle', 'MarcoFreeplay', 24);
   framee.animation.play('idle');
   framee.scale.set(0.7,0.7);
   add(framee);
   
   cuteRect = new FlxRect(114, 154, 400, 383);

   track = new FunkinSprite(47,118).loadGraphic(Paths.image('menus/freeplay/track'));
   track.antialiasing=true;
   track.scale.set(0.7,0.7);
   track.updateHitbox();
   add(track);
	
   thumb = new FunkinSprite(55,148).loadGraphic(Paths.image('menus/freeplay/thumb'));

   thumb.antialiasing=true;
   thumb.scale.set(0.7,0.7);
   thumb.updateHitbox();
   add(thumb);

	songsGroup = new FlxSpriteGroup(0,0);
	add(songsGroup);
	songsGroup.clipRect = cuteRect;





   for (i in 0...songs.length)
	{
	   
		var songText = new FlxText(110,yOffset, 300, songs[i].name, 27);
		songText.antialiasing=true;	
		songText.alignment = FlxTextAlign.CENTER;
		songText.font = Paths.font('Elemental End.ttf');
		songText.setBorderStyle(FlxTextBorderStyle.SHADOW, 0xFFcc0000, 6,1);
		songText.ID = i;

		songsGroup.add(songText);

		yOffset += songText.height + separation; 
		
	
		totalHeight += songText.height +separation;
		if(Reflect.field(songs[i].customValues, "allowedChars") ==null)
			originsMap.set(songs[i].name, ["everyone"]);
		else {
			var ind:Array<String> = Reflect.field(songs[i].customValues, "allowedChars");
			originsMap.set(songs[i].name, ind);


		}

			var charsArr = originsMap.get(songs[i].name);

			if(!charsArr.contains(selectedChar) && !charsArr.contains("everyone")){
				songText.alpha = 0.7;

			}
			else if(charsArr.contains(selectedChar)||charsArr.contains("everyone")){
				songText.alpha=1;

			}

			
		
		
	  
	}
	
	trace(originsMap);

	for(song in songsGroup){
		positions.push(song.y);
	}
	minY = track.y + thumb.height / 2 - 15;
	maxY = track.y + track.height - thumb.height / 2 - 75;

	maxScroll = totalHeight;

	diffSelectors = new FlxSpriteGroup();
	add(diffSelectors);

	var idling = ['DifHard', 'DifNormal', 'DifEasy'];
	var selected = ['DifSelectHard', 'DifSelectNormal', 'DifSelectEasy'];

	for(i in 0...3){
		var diffSel = new FunkinSprite(431,198 + (i*65));

		diffSel.frames = Paths.getFrames('menus/freeplay/FreeplayStuff');
		diffSel.animation.addByPrefix('idle', idling[i], 24, true);
		diffSel.animation.addByPrefix('selected', selected[i], 24, false);
		diffSel.antialiasing= true;
		diffSel.animation.play('idle');
		diffSel.scale.set(0.7,0.7);
		diffSel.updateHitbox();
		diffSel.height *= 0.3;
		diffSel.centerOffsets();
		diffSel.ID = i;
		diffSel.alpha =0;
		diffSelectors.add(diffSel);
		switch(i){
			case 0: //hard
			
	
					diffSel.ID = 2;
					diffSel.addOffset('idle',0,0);
	
					diffSel.addOffset('selected',-28,-28);


			
			case 1: //normal
		
		
					diffSel.addOffset('idle', 0,0);

		
					diffSel.addOffset('selected',-28,-28);

			
			case 2: //easy
		
				diffSel.ID = 0;

					diffSel.addOffset('idle', 0,0);

		
					diffSel.addOffset('selected', -28,-28);

			
		}
		
		//if(i==2)diffSel.y -= 10;
	
	}

	scoreText = new FlxText(framee.x + 220,framee.y + 445,0,'', 25);
	scoreText.antialiasing=true;
	scoreText.angle = -3;
	scoreText.font = Paths.font('Elemental End.ttf');
	add(scoreText);

	loadJson();
	changeSelection(1); 
	changeDiff(0);

	coolBg.loadGraphic(Paths.image('menus/freeplay/covers/'+coolData[curSelected].sprName));

	
	

	var lineStuff = new FlxSprite(0,0).loadGraphic(Paths.image('menus/freeplay/Menu-Barss'));
	lineStuff.scale.set(1.2,1);
	lineStuff.antialiasing= true;
	add(lineStuff);

	FlxG.camera.alpha = 0;
	FlxG.camera.zoom = 2;
	FlxTween.tween(FlxG.camera, {zoom: 1, alpha: 1}, 1, {ease: FlxEase.expoInOut});

}
var mouse:FlxSprite;
	var arrow:FlxSprite;
public var thumb:FlxSprite;
public var track:FlxSprite;
var positions:Array<Float>=[];
var isDragging:Bool = false;  // Indica si el usuario está arrastrando la barra de desplazamiento
var clickOffset:Float;  // Al
var yOffset:Float = 160; // Posición vertical inicial
var separation:Float = 25; // Separación entre textos
var prevPosition:Float;
var minY:Float;
var maxY:Float;
// Calcula el desplazamiento máximo basado en la altura total de la lista y el área visible
var maxScroll:Float;
// Maneja el arrastre del pulgar
 function checkRectContainsPoint(rect:FlxRect, y:Float):Bool {
	
	   return y >= rect.y && y <= rect.y + rect.height;
}


var desiredY:Float;
function handleThumbDragging():Void {
	if (isDragging) {
		var newPosition = FlxG.mouse.y - clickOffset;

		newPosition = Math.max(newPosition, minY);
		newPosition = Math.min(newPosition, maxY);

		var thumbDelta = newPosition - thumb.y; 

		thumb.y = FlxMath.lerp(thumb.y, newPosition, 0.8);

		
		
	}
	else{
		if(FlxG.mouse.wheel != 0){
			var scrollAmount = 10; 
			thumb.y -= FlxG.mouse.wheel * scrollAmount;

			
			thumb.y = Math.max(minY, Math.min(maxY, thumb.y));
		}
	}

	if (FlxG.mouse.pressed && FlxG.mouse.overlaps(thumb)) {
		isDragging = true;
		clickOffset = FlxG.mouse.y - thumb.y;
	}

	if (FlxG.mouse.released) {
		isDragging = false;
	}
	
}
var coolData:Dynamic;
 function loadJson(){
	coolData = Json.parse(Assets.getText('assets/data/freeplaymeta.json'));


}
public function changeSelection(change:Int = 0, force:Bool = false)
	{
		if (change == 0 && !force) return;

		var bothEnabled = songs[curSelected].coopAllowed && songs[curSelected].opponentModeAllowed;
		var event = event("onChangeSelection", EventManager.get(MenuChangeEvent).recycle(curSelected, FlxMath.wrap(curSelected + change, 0, songs.length-1), change));
		if (event.cancelled) return;

		curSelected = change;


		#if PRELOAD_ALL
			autoplayElapsed = 0;
			songInstPlaying = false;
		#end
		changeDiff(1);

		trace('song is'+songList.songs[curSelected].name);
	
		var songData = Chart.loadChartMeta(songs[curSelected].name, 'normal');
		Conductor.changeBPM(songData.bpm);
	
		var future: Future<BitmapData> = BitmapData.loadFromFile('assets/images/menus/freeplay/covers/'+coolData[curSelected].sprName + '.png');
        future.onComplete(function(bitmap) {
			
			coolBg.loadGraphic(bitmap);

			
        });
		future.onError (function (error) { trace (error); });
		
		future.onProgress (function (loaded, total) { trace ("Loading: " + loaded + ", " + total); });

		
	
	
	
	}
	
	function beatHit(curBeat:Int) {
		
		coolBg.scale.set(1.2, 1.2);
	}
	public var autoplayElapsed:Float = 0;
	public var songInstPlaying:Bool = true;
	public var disableAutoPlay:Bool = false;
	public var timeUntilAutoplay:Float = 1;
	public var curPlayingInst:String = null;
	var songDelta:Float;
	var shit:FlxPoint = new FlxPoint(0,0);
	var coolTimer:Float=0;
	function update(elapsed) {
		


	}
	var canClick:Bool = true;
	public function changeDiff(change:Int = 0, force:Bool = false)
		{
	
			var curSong = songs[curSelected];
			var validDifficulties = curSong.difficulties.length > 0;
			var event = event("onChangeDiff", EventManager.get(MenuChangeEvent).recycle(curDifficulty, validDifficulties ? FlxMath.wrap(curDifficulty + change, 0, curSong.difficulties.length-1) : 0, change));
	
			if (event.cancelled) return;
	
			curDifficulty = change;
	
	
			updateScore();
	
		}
		public function select() {

	
			if (songs[curSelected].difficulties.length <= 0) return;
	
			//var event = event("onSelect", EventManager.get(FreeplaySongSelectEvent).recycle(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty], __opponentMode, __coopMode));
	
			if (event.cancelled) return;
	
			Options.freeplayLastSong = songs[curSelected].name;
			Options.freeplayLastDifficulty = songs[curSelected].difficulties[curDifficulty];
	
			PlayState.loadSong(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty], false, 0);

			new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					FlxG.switchState(new ModState('LoadingState'));
				});
			FlxG.camera.flash(FlxColor.RED, 1);

			FlxTween.tween(FlxG.camera, {zoom: 2, alpha: 0}, 1, {ease: FlxEase.expoInOut});

			
		}
		public var lerpScore:Int = 0;

		function updateScore() {
			
			if (songs[curSelected].difficulties.length <= 0) {
				intendedScore = 0;
				trace('setting score to 0');
				return;
			}
			var changes:Array<HighscoreChange> = [];
	
		
			var difficulty:String = songs[curSelected].difficulties[curDifficulty].toLowerCase();
			trace(difficulty);
			
			var saveData = FunkinSave.getSongHighscore(songs[curSelected].name, difficulty, changes);
		
			intendedScore = saveData.score;
		}

		var canClickDiff:Bool = false;
	function postUpdate(elapsed:Float){
	

		if(Conductor.bpm>180)
			coolBg.scale.set(lerp(coolBg.scale.x, 1, 0.010), lerp(coolBg.scale.y, 1, 0.010));
			else 
			coolBg.scale.set(lerp(coolBg.scale.x, 1, 0.0070), lerp(coolBg.scale.y, 1, 0.0070));
	
			coolTimer+=elapsed;
			glitch.iTime = coolTimer;

		lerpScore = Math.floor(lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = lerpScore;

		if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.7)
			{
				FlxG.sound.music.volume += 0.5 * elapsed;
			}
	
		songsGroup.clipRect = cuteRect;

		handleThumbDragging();

		var thumbScrollPercentage = (thumb.y - minY) / (maxY - minY);
		songDelta = thumbScrollPercentage * (maxScroll - cuteRect.height);

	
	
	
		if(!diffSelection)
		for (song in songsGroup)
			{
				if(song!=null){
					song.y = positions[song.ID] - cuteRect - songDelta;

				


	
	
	
					if(FlxG.mouse.overlaps(song) && checkRectContainsPoint(cuteRect,song.y + 20)){
					   if(curSelected!=song.ID && canClick && (originsMap.get(songs[song.ID].name).contains(selectedChar)||originsMap.get(songs[song.ID].name).contains("everyone"))){
					
							changeSelection(song.ID, true); 

						  
		   
					   }

					   if((controls.BACK||FlxG.mouse.justPressedRight||FlxG.mouse.justPressed && !FlxG.mouse.overlaps(diffSelectors)) && canClick){
						trace('clicking');
						canClick = false;
						for(d in diffSelectors){
							FlxTween.tween(d, {alpha:1}, 1 + (d.ID*0.50), {ease: FlxEase.expoInOut,onComplete:function(_){
								if(d.ID == 1){
									
										trace('completed welcome tweens lol ');
										canClickDiff = true;

										diffSelection = true;

								}
							}});
							}
						}

					}
					
				}
				
	
			 
			}
			else{
				for(diff in diffSelectors){
					if(FlxG.mouse.overlaps(diff)){
						diff.playAnim('selected');

						if(curDifficulty!=diff.ID){
							
							changeDiff(diff.ID);

						}

						if(FlxG.mouse.justPressed){
							

						
							canClick=false;
							select();
								
						}
					}
					else{
						diff.playAnim('idle');

					}
				}
					if( (!FlxG.mouse.overlaps(diffSelectors) && FlxG.mouse.justPressed) && canClickDiff){
							canClickDiff = false;
							for(d in diffSelectors){
								FlxTween.tween(d, {alpha:0}, 1 + (d.ID*0.50), {ease: FlxEase.expoInOut,onComplete:function(_){
									if(d.ID == 1){
										
											trace('completed leave tweens  lol ');
								
											canClick = true;
											diffSelection = false;
									}
								}});
							}
						
						
						
						
					}
				
			}
				
			
	
			
			if(songsGroup.members[curSelected].height>40){
				selectSqr.y =  songsGroup.members[curSelected].y + selectSqr.height - 78;
	
			}
			else{
				selectSqr.y = songsGroup.members[curSelected].y + selectSqr.height - 93;
	
			}
	
	
			
			if(checkRectContainsPoint(cuteRect,songsGroup.members[curSelected].y + 20)){
				selectSqr.alpha=1;
			}
			else{
				selectSqr.alpha=0;

			}

			var dontPlaySongThisFrame = false;
			autoplayElapsed += elapsed;
			if (!disableAutoPlay && !songInstPlaying && (autoplayElapsed > timeUntilAutoplay || FlxG.keys.justPressed.SPACE)) {
				if (curPlayingInst != (curPlayingInst = Paths.inst(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty]))) {
					//var huh:Void->Void = function()FlxG.sound.playMusic(curPlayingInst, 0);
					if(!disableAsyncLoading) Main.execAsync(showSongStuff);
					else showSongStuff();
				}
				songInstPlaying = true;
				if(disableAsyncLoading) dontPlaySongThisFrame = true;
			}
		
			if(controls.BACK){
				FlxG.switchState(new MainMenuState());
			}
	}
	var diffSelection:Bool = false;

	function showSongStuff() {
		FlxG.sound.playMusic(curPlayingInst, 0);

		
	}
