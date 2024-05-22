package funkin.menus;

import haxe.Json;
import funkin.backend.FunkinText;
import funkin.menus.credits.CreditsMain;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import funkin.backend.scripting.events.*;
import openfl.events.Event;
import funkin.options.OptionsMenu;
import hxvlc.flixel.FlxVideoSprite;
import flixel.util.FlxTimer;
import openfl.system.System;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;
import openfl.net.FileFilter;

using StringTools;

class MainMenuState2 extends MusicBeatState
{
	var _file:FileReference;

	var curSelected:Int = 0;
	public var currentOptions:Options;
	var scroll:Bool = true;
	var subScroll:Bool = false;
	var madnessBg:FlxSprite;
	var wallButton:FlxSprite;
	var subWall:FlxSprite;
	var mouse:FlxSprite;
	var arrow:FlxSprite;
	var logoMadness:FlxSprite;
	var daGroup:FlxTypedGroup<FlxSprite>;
	var songsList:Array<String>=['Benzemadness', 'BlueBrassOfTheBeast', 'FreeSongsToPlay', 'FrenzyMadness', 'ImprobableAC1D', 'SoManyBackgrounds', 'TheBdaySong', 'TheReturnOfTheEmperor'];
	var curSong:String;
	var pauseSound:Bool = false;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var subMenuItems:FlxTypedGroup<FlxSprite>;

	public var canAccessDebugMenus:Bool = true;



	var optionShit:Array<String> = ['Story', 'Arena', 'Char', 'Shop', 'Options', 'Exit'];
	

	var subOptionShit:Array<String> = ['Freeplay', 'Versus', 'Madness'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var numba:Int=0;
	var daProcess:String;
	var _login:FlxSprite;
	var songSpr:FlxSprite;
	var shouldPlayAnim:Bool = false;

	var video:FlxVideoSprite;
	
	var angled:Bool = false;

	override function create() {
		super.create();
		songSpr = new FlxSprite(940,591);
		songSpr.frames = Paths.getFrames('menus/madnessmainmenu/NowPlaying');
		if(FlxG.sound.music == null || !FlxG.sound.music.playing){
			FlxG.sound.playMusic(Paths.music('randomSongs/${curSong}'));
			songSpr.animation.addByPrefix('now', 'NowPlaying_${curSong}', 24, false);
			shouldPlayAnim = true;
		}
		else if(Type.getClassName(Type.getClass(MusicBeatState.lastState))==Type.getClassName(Type.getClass(new TitleState()))){
			trace('we came from titlestate');
			songSpr.animation.addByPrefix('now', 'NowPlaying_${TitleState.curSong}', 24, false);
			shouldPlayAnim = true;


		}
		else if(Type.getClassName(Type.getClass(MusicBeatState.lastState))!=Type.getClassName(Type.getClass(new TitleState())) && FlxG.sound.music.playing){
			trace('we came from another state'); 

			curSong = songsList[FlxG.random.int(0, songsList.length-1)];

			FlxG.sound.playMusic(Paths.music('randomSongs/${curSong}'));
			songSpr.animation.addByPrefix('now', 'NowPlaying_${curSong}', 24, false);
			shouldPlayAnim = true;

		}

		FlxG.camera.alpha = 0;
		FlxG.camera.zoom = 2;
		persistentUpdate = persistentDraw = true;
		FlxTween.tween(FlxG.camera, {zoom: 1, alpha: 1}, 1, {ease: FlxEase.expoInOut});

	

		video= new FlxVideoSprite(0,0);
		video.load(Paths.video('looper'));
		video.play();

	   add(video);
	

	   arrow = new FlxSprite(695, 200).loadGraphic(Paths.image('menus/madnessmainmenu/arrow'));
		arrow.scale.set(0.1, -0.1);
		arrow.antialiasing = true;
		arrow.alpha = 0;

		logoMadness = new FlxSprite(0, 30).loadGraphic(Paths.image('menus/madnessmainmenu/madness logo nexus'));
		logoMadness.scale.set(0.2, 0.2);
		logoMadness.updateHitbox();
		logoMadness.screenCenter(X);
		logoMadness.antialiasing = true;
		add(logoMadness);
		// magenta.scrollFactor.set();

		daGroup = new FlxTypedGroup<FlxSprite>();

		wallButton = new FlxSprite(471, 180);
		wallButton.frames = Paths.getFrames('menus/madnessmainmenu/WallButton');
		wallButton.animation.addByPrefix('appear', 'wallButton', 24, false);
		wallButton.antialiasing = true;

		FlxTween.tween(wallButton, {"scale.y": 0.94}, 5, {
			type: PINGPONG
		});

		
		subWall = new FlxSprite(808, 242);
		subWall.frames = Paths.getFrames('menus/madnessmainmenu/subWallButton');
		subWall.animation.addByPrefix('intro', 'appear', 24, false);
		subWall.scale.set(1, 1);
		subWall.antialiasing = true;
		subWall.alpha = 0;

		add(subWall);
		add(wallButton);
		wallButton.animation.play('appear');

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		subMenuItems = new FlxTypedGroup<FlxSprite>();
		add(subMenuItems);

		
		var tex = Paths.getFrames('menus/madnessmainmenu/buttonShit');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 200 + (i * 70));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " Off", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " On", 24);
			menuItem.animation.play('idle');
			menuItem.alpha = 0;
			menuItem.ID = i;

			switch (i)
			{
				case 4:
					menuItem.y = 496;
				case 5:
					menuItem.y = 543;
			}

			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.antialiasing = true;
			FlxTween.tween(menuItem, {alpha: 1}, 1 + (i * 0.25), {ease: FlxEase.expoInOut});
		}

		for (i in 0...subOptionShit.length)
		{
			var sub:FlxSprite = new FlxSprite(subWall.x + 15, subWall.y + 17 + (i * 50));
			sub.frames = Paths.getFrames('menus/madnessmainmenu/subButtonShit');
			sub.animation.addByPrefix('sub-idle', subOptionShit[i] + " Off", 24);
			sub.animation.addByPrefix('sub-selected', subOptionShit[i] + " On", 24);
			sub.animation.play('sub-idle');
			sub.ID = i;
			sub.alpha = 0;
			subMenuItems.add(sub);
			sub.antialiasing = true;
		}

		changeItem();

		FlxG.mouse.visible = false;

		mouse = new FlxSprite().loadGraphic(Paths.image('menus/madnessmainmenu/mouseSprite'));
		mouse.scale.set(0.06, 0.06);
		mouse.antialiasing = true;

		add(arrow);
		
		_login = new FlxSprite(29,626 -100);
		//_login.frames = Paths.getFrames('FNM gamejolt');
		_login.antialiasing=true;
		//_login.animation.addByPrefix('idle', 'GamejoltButton', 24, false);
		//7_login.animation.addByPrefix('select', 'Select_GamejoltButton', 24, false);
		//_login.animation.play('idle');
		_login.width -= 770;
		//add(_login);

		add(mouse);

	
		new FlxTimer().start(1, function(_){
			if(shouldPlayAnim){
				songSpr.animation.play('now');
				add(songSpr);
			}
		
		});
	



	}
	function changeItem(huh:Int = 0,force:Bool=false)
		{
			if(force){
				curSelected=huh;
			}else{
				curSelected += huh;
	
				if (curSelected >= menuItems.length)
					curSelected = 0;
				if (curSelected < 0)
					curSelected = menuItems.length - 1;
			}
	
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.animation.play('idle');
	
				if (spr.ID == curSelected)
				{
					spr.animation.play('selected');
				}
	
				spr.updateHitbox();
			});
		}
	override function update(elapsed:Float) {
		
		if (canAccessDebugMenus) {
			if (FlxG.keys.justPressed.SEVEN) {
				persistentUpdate = false;
				persistentDraw = true;
				openSubState(new funkin.editors.EditorPicker());
			}
			/*
			if (FlxG.keys.justPressed.SEVEN)
				FlxG.switchState(new funkin.desktop.DesktopMain());
			if (FlxG.keys.justPressed.EIGHT) {
				#if sys
				sys.io.File.saveContent("chart.json", Json.stringify(funkin.backend.chart.Chart.parse("dadbattle", "hard")));
				#end
			}
			*/
		}
		if (!angled)
			{
				FlxTween.tween(wallButton, {angle: FlxG.random.int(-3, 3)}, 5, {
					type: PINGPONG,
					onComplete: function(_)
					{
						angled = false;
					}
				});
	
				angled = true;
			}
			for (si in 0...menuItems.length)
				{
					menuItems.members[si].angle = wallButton.angle;
					menuItems.members[si].scale.y = wallButton.scale.y;
				}

				mouse.setPosition(FlxG.mouse.x, FlxG.mouse.y);
				mouse.updateHitbox();
				if (FlxG.mouse.overlaps(menuItems) && scroll == true || FlxG.mouse.overlaps(subMenuItems) && subScroll == true)
					{
						if (!pauseSound)
						{
							FlxG.sound.play(Paths.sound('scrollMouse'));
			
							pauseSound = true;
						}
					}
					else
					{
						pauseSound = false;
					}

					if (scroll)
						{
							for (item in 0...menuItems.length)
							{
								if (FlxG.mouse.overlaps(menuItems.members[item]))
								{
									menuItems.members[item].animation.play('selected');
				
									if (FlxG.mouse.justPressed)
									{
										switch (Math.abs(item))
										{
											case 0:
												handleClick(0, false);
											case 1:
												appearSub();
											case 2:
												handleClick(2, false);
											case 3:
											case 4:
												handleClick(4, false);
											case 5:
												handleClick(5, false);
										}
									}
								}
								else
									menuItems.members[item].animation.play('idle');
							}
						}
						if (subScroll)
							{
								if (FlxG.keys.justPressed.ESCAPE)
								{
									for (i in 0...subOptionShit.length)
									{
										FlxTween.tween(subMenuItems.members[i], {alpha: 0}, 0.3 + (i * 0.25), {
											ease: FlxEase.expoInOut,
											onComplete: function(twn:FlxTween)
											{
												FlxTween.tween(arrow, {alpha: 0}, 0.2);
												FlxTween.tween(subWall, {alpha: 0}, 0.2, {
													onComplete: function(twn:FlxTween)
													{
														subScroll = false;
														scroll = true;
													}
												});
											}
										});
									}
								}
								for (item in 0...subMenuItems.length)
								{
									if (FlxG.mouse.overlaps(subMenuItems.members[item]))
									{
										subMenuItems.members[item].animation.play('sub-selected');
										if (FlxG.mouse.justPressed)
										{
											switch (Math.abs(item))
											{
												case 0:
													handleClick(0, true);
												case 1:
													handleClick(1, true);
												case 2:
													handleClick(2, true);
											}
										}
									}
									else
										subMenuItems.members[item].animation.play('sub-idle');
								}
							}
							#if debug
							if (FlxG.keys.justPressed.EIGHT) {
								var data = [
									{
										question: "WHOS THE CREATOR OF THE MADNESS COMBAT SERIES?",
										options: ['KRINKELS', 'KRONKELS', 'KRUNKELS'],
										answer: 0
									},
									{
										question: 'WHATS JEBUS FIRST NAME?',
										options: ['JEBUS', 'JEBEDIAH', 'GOD'],
										answer: 1
									}
								];

								save(Json.stringify(data,"\t"),'questions.json');
							}
							#end

		super.update(elapsed);
		menuItems.forEach(function(spr:FlxSprite)
			{
				spr.screenCenter(X);
			});
	}
	
	private function save(data:String,name:String)
		{
		  if ((data != null) && (data.length > 0))
		  {
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), name);
		  }
		}
	  
		function onSaveComplete(_):Void
		{
		  _file.removeEventListener(Event.COMPLETE, onSaveComplete);
		  _file.removeEventListener(Event.CANCEL, onSaveCancel);
		  _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		  _file = null;
		  FlxG.log.notice("Successfully saved LEVEL DATA.");
		 
		}
	  
		function onSaveCancel(_):Void
		{
		  _file.removeEventListener(Event.COMPLETE, onSaveComplete);
		  _file.removeEventListener(Event.CANCEL, onSaveCancel);
		  _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		  _file = null;
	   
		}
	  
		function onSaveError(_):Void
		{
		  _file.removeEventListener(Event.COMPLETE, onSaveComplete);
		  _file.removeEventListener(Event.CANCEL, onSaveCancel);
		  _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		  _file = null;
		  FlxG.log.error("Problem saving Level data");
	  
		}
	function appearSub()
		{
			subWall.alpha = 1;
			subWall.animation.play('intro');
	
			FlxTween.tween(arrow, {alpha: 1}, 0.2);
	
			for (i in 0...subOptionShit.length)
			{
				FlxTween.tween(subMenuItems.members[i], {alpha: 1}, 1 + (i * 0.25), {ease: FlxEase.expoInOut});
			}
	
			scroll = false;
			subScroll = true;
		}
	function handleClick(id:Int,sub:Bool){
		scroll = false;
		subScroll = false;
		FlxG.sound.music.pause();
			
		FlxG.camera.flash(FlxColor.RED, 1);
		new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				if(!sub){
					switch (id)
					{
						case 0:
							FlxG.switchState(new StoryMenuState());
							trace('story');
						case 2:
	
						//FlxG.switchState(new NewCharacterSelectState());
	
						case 4:
							FlxG.switchState(new OptionsMenu());
							trace('option');
	
						case 5:
							System.exit(0);
					}
				}
					else{
						switch (id)
						{
							case 0:
							
								FlxG.switchState(new FreeplayState());
								trace('freeplay');

							case 1:

								FlxG.switchState(new FreeplayState());
								trace('freeplay');

							case 2:
								FlxG.switchState(new FreeplayState());
								trace('freeplay');


								//FlxG.switchState(new MadnessState());
						}
					}
					
					var loop:Int = 0;
		
					menuItems.forEach(function(spr:FlxSprite)
					{
						loop++;
						FlxTween.tween(spr, {alpha: 1}, 1 + (loop * 0.25), {ease: FlxEase.expoInOut});
					});
		
					//video.destroy();
					FlxTween.tween(FlxG.camera, {zoom: 2, alpha: 0}, 1, {ease: FlxEase.expoInOut});
			});
		
	}
}
