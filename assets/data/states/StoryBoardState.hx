import funkin.backend.FunkinSprite;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.savedata.FunkinSave;
import haxe.io.Path;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import funkin.backend.FunkinText;
import Xml;
import flixel.text.FlxText;
import funkin.backend.assets.AssetsLibraryList;
import flixel.FlxObject;

var photoData:Array<Dynamic>=[];
public var localWeeks:Array<WeekData> = [];
var bg:FlxSprite;
var rad:FlxSprite;
var storyIndicator:FlxSprite;
var weekBar:FlxSprite;
var charName:FlxSprite;
var camFollow:FlxObject;
//info
var curWeek:Int = 0;
var curDiff:Int=0;
var curPhoto:Int = 0;
var diffs = ['EASY', 'MEDIUM', 'HARD'];
var selectingDiff:Bool = false;

//groups
var photos:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();

var difficulties:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var cantMove:Bool = true;

var camHUD:FlxCamera = new FlxCamera();
function displayDiffs(in:Bool){
	var val:Float = in == true ? 1 : 0;
	var daEase =  FlxEase.expoInOut;
	FlxTween.tween(weekBar, {alpha:val}, 0.4, {ease:daEase});
	FlxTween.tween(charName, {alpha:val}, 0.6, {ease:daEase});
	cantMove = in;

	for(d in difficulties){
			FlxTween.tween(d, {alpha:val},1 + (d.ID*0.50), {ease:daEase, onComplete:function(_){
					if(d.ID == 0){
							selectingDiff = in;
							
							if(!in)changeDif(0);

					}
			}});
	}
}
function loadWeek(){
	storyWeek = curWeek;
	trace("storyWeek is" + curWeek);
	displayDiffs(false);
	PlayState.loadWeek(localWeeks[curWeek], localWeeks[curWeek].difficulties[curDiff]);

	new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxG.switchState(new ModState('LoadingState'));
		});
	camHUD.flash(FlxColor.RED, 1);

	FlxTween.tween(FlxG.camera, {zoom: 10, alpha: 0}, 1, {ease: FlxEase.expoInOut});




		
}
function changeDif(plus:Int=0){
	curDiff+=plus;

	if(curDiff>diffs.length-1)
	curDiff = 0;
	else if(curDiff<0)
	curDiff = diffs.length-1;
	
	for(d in difficulties){
		d.playAnim('idle');
			if(d.ID == curDiff){
				d.playAnim('selected');
			}
	}
}

function changeSelection(plus:Int = 0, ?force:Bool = false){
               
	var prevWeek = curWeek;
	curWeek += plus;
	if(force)
	curWeek = plus;
	if(curWeek>weekUnlocked.length-1)
	curWeek = 0;
	else if(curWeek<0)
	curWeek = weekUnlocked.length-1;
	
	
	camFollow.setPosition(photoData[curWeek].camPos[0], photoData[curWeek].camPos[1]);
	storyIndicator.animation.play(photoData[curWeek].storyType);
	charName.animation.play(photoData[curWeek].displayName);


	trace(localWeeks[curWeek].songs);
}
function unlockWeeks():Array<Bool>
	{
		var weeks:Array<Bool> = [];
		

		weeks.push(true);

		for (i in 0...FlxG.save.data.weekUnlocked)
		{
			weeks.push(true);
		}
		return weeks;
	}

function postCreate() {
	loadXMLs();
	globalWeekData = localWeeks;

	weekUnlocked = unlockWeeks();

	trace(weekUnlocked);
	camHUD.bgColor = 0;
	FlxG.cameras.add(camHUD, false);
	
	FlxG.camera.alpha = 0;
	FlxG.camera.zoom = 10;

	FlxTween.tween(FlxG.camera, {zoom: 3.1, alpha: 1}, 1, {ease: FlxEase.expoInOut});

	add( bg = new FlxSprite(0,0).loadGraphic(Paths.image('menus/StoryBoard/Background')));
	bg.antialiasing=true;
	bg.scrollFactor.set();

	for(i in 0...weekUnlocked.length){
		
		var photo = new FlxSprite(photoData[i].photoPos[0],photoData[i].photoPos[1]);
		photo.frames = Paths.getSparrowAtlas('menus/StoryBoard/StoryWeeksStuff');
		photo.antialiasing=true;
		photo.animation.addByPrefix(photoData[i].photoName, photoData[i].photoName, 24, false);
		photo.animation.play(photoData[i].photoName);
		photo.ID= i;
		photo.scale.set(0.309999999999999,0.309999999999999);
		photo.updateHitbox();
		photos.add(photo);
		
		var thread = new FlxSprite(photoData[i].threadPos[0],photoData[i].threadPos[1]);
		thread.frames = Paths.getSparrowAtlas('menus/StoryBoard/StoryWeeksStuff');
		thread.antialiasing=true;
		thread.animation.addByPrefix('idle', photoData[i].threadName, 24, false);
		thread.animation.play('idle');
		thread.ID= i;
		thread.scale.set(0.309999999999999,0.309999999999999);
		thread.updateHitbox();
		if(i<weekUnlocked.length-1){
		photos.add(thread);
		}

		pin = new FlxSprite(photoData[i].pinPos[0],photoData[i].pinPos[1]);
	
		pin.frames = Paths.getSparrowAtlas('menus/StoryBoard/StoryWeeksStuff');
		pin.antialiasing=true;
		pin.animation.addByPrefix('idle', 'Chinche', 24, false);
		pin.animation.play('idle');
		pin.ID= i;

		pin.scale.set(0.309999999999999,0.309999999999999);
		pin.updateHitbox();
		photos.add(pin);
	}
	add(photos);


	camFollow = new FlxObject(0, 0, 1, 1);
	add(camFollow);
	
	FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON,0.05);
	FlxG.camera.focusOn(camFollow.getPosition());
	camFollow.setPosition(photoData[curWeek].camPos[0], photoData[curWeek].camPos[1]);

	add(rad = new FlxSprite(-3,0).loadGraphic(Paths.image('menus/StoryBoard/Degradado radial')));
	rad.antialiasing = true;
	rad.scrollFactor.set();
	rad.setGraphicSize(Std.int(rad.frameWidth*0.329999999999999));

 
	storyIndicator = new FlxSprite(24,46);
	storyIndicator.frames = Paths.getSparrowAtlas('menus/StoryBoard/StoryModeStuff');
	storyIndicator.animation.addByPrefix('normal', 'MainStory', 24, false);
	storyIndicator.animation.addByPrefix('alt', 'AltStory', 24, false);
	storyIndicator.animation.addByPrefix('???', 'OtherStory', 24, false);
	storyIndicator.antialiasing = true;
	storyIndicator.animation.play('normal');
	storyIndicator.cameras = [camHUD];
	storyIndicator.scrollFactor.set();
	add(storyIndicator);

	weekBar = new FlxSprite(796,243);
	weekBar.frames = Paths.getSparrowAtlas('menus/StoryBoard/StoryModeStuff');
	weekBar.animation.addByPrefix('appear', 'WeekBar', 24, true);
	weekBar.antialiasing = true;
	weekBar.alpha = 0;
	weekBar.animation.play('appear');
	weekBar.cameras = [camHUD];
	weekBar.scrollFactor.set();
	add(weekBar);

	charName = new FlxSprite(773,212);
	charName.frames = Paths.getSparrowAtlas('menus/StoryBoard/StoryModeStuff');
	for(data in photoData)charName.animation.addByPrefix(data.displayName, data.displayName, 24, false);	
	charName.antialiasing = true;
	charName.alpha = 0;
	charName.cameras = [camHUD];
	charName.scrollFactor.set();
	add(charName);

	for(i in 0...diffs.length){
                              
		var dif = new FunkinSprite(848,269 +(i*70));
		dif.frames = Paths.getSparrowAtlas('menus/StoryBoard/StoryModeStuff');
		dif.animation.addByPrefix('idle', diffs[i]+'0', 24, true);
		dif.animation.addByPrefix('selected', diffs[i]+'_SELECT0', 24, true);
		dif.animation.play('idle');
		dif.alpha=0;
		dif.ID = i;
		dif.addOffset("idle",0,0);
		dif.addOffset("selected",9,7);

		dif.cameras = [camHUD];
		dif.scrollFactor.set();
		difficulties.add(dif);
	}
	add(difficulties);


	add(overlay = new FlxSprite().loadGraphic(Paths.image('menus/StoryBoard/StoryModeThing')));
	overlay.antialiasing = true;
	overlay.cameras = [camHUD];
	overlay.scrollFactor.set();


	changeSelection(storyWeek);
	changeDif(0);
	if(storyAuto)
		autoMode();
}
var overlay:FlxSprite;
function update(elapsed){
	
	if(controls.UP_P)
		selectingDiff == false ? changeSelection(-1): changeDif(-1);
	if(controls.DOWN_P)
		selectingDiff == false ? changeSelection(1): changeDif(1);
	if(controls.ACCEPT) 
		selectingDiff == false ? displayDiffs(true):loadWeek();
	if(controls.BACK)
		selectingDiff == false ? FlxG.switchState(new MainMenuState()):displayDiffs(false);
	


					   
	if(FlxG.keys.justPressed.ALT){
		storyAuto = !storyAuto;	

		autoMode();

	}


	   
}
function autoMode(){
	if(weekUnlocked.length == localWeeks.length){
		trace("all weeks are completed");
		storyAuto=false;
		return;

	}
	trace("auto mode is" +storyAuto);
	new FlxTimer().start(1, function(_){
		if(!storyAuto)return;
		changeSelection(weekUnlocked.length-1, true);
		curDiff = 1;
		new FlxTimer().start(1, function(_){
			if(!storyAuto)return;
			loadWeek();
		});
	});
}
public function getWeeksFromSource(weeks:Array<String>, source:funkin.backend.assets.AssetsLibraryList.AssetSource) {
	var path:String = Paths.txt('freeplaySonglist');
	var weeksFound:Array<String> = [];
	if (Paths.assetsTree.existsSpecific(path, "TEXT", source)) {
		var trim = "";
		weeksFound = CoolUtil.coolTextFile(Paths.txt('weeks/weeks'));
	} else {
		weeksFound = [for(c in Paths.getFolderContent('data/weeks/weeks/', false, source)) if (Path.extension(c).toLowerCase() == "xml") Path.withoutExtension(c)];
	}
	
	if (weeksFound.length > 0) {
		for(s in weeksFound){
			weeks.push(s);
	

		}
		return false;
	}
	return true;
}

public function loadXMLs() {
	// CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
	var weeks:Array<String> = [];
	if (getWeeksFromSource(weeks, false))
		getWeeksFromSource(weeks, true);

	for(k=>weekName in weeks) {

		var week = null;
		
		week = Xml.parse(Assets.getText(Paths.xml('weeks/weeks/'+weekName))).firstElement();
		
		var weekObj:WeekData = {
            name: week.get("name"),
            id: weekName,
            sprite: week.get("sprite"),
            chars: [null, null, null],
            songs: [],
            difficulties: ['easy', 'normal', 'hard']
        };

		var songNodes = week.elementsNamed("song");
        if (songNodes != null && songNodes.hasNext()) {
            var k2 = 0;
            while (songNodes.hasNext()) {
                var song = songNodes.next();
                if (song == null) continue;

                var name = MoarUtils.get_innerData(song);
				name = StringTools.trim(name);
				
				weekObj.songs.push({
					name: name,
					hide: song.get("hide", "false") == "true"
				});

                k2++;
            }
        }
	
		localWeeks.push(weekObj);


	}
	for (i in 1...13) {
	

		var xml:Xml = Xml.parse(Assets.getText(Paths.xml('boardData/pic'+i))).firstElement();

	
		var positionsXml:Xml = xml.elements().next();
		var displayName:String = xml.get("displayName");
		var photoName:String = xml.get("photoName");
		var threadName:String = xml.exists("threadName") ? xml.get("threadName") : null;
		var photoPos:Array<Float> = positionsXml.get("photoPos").split(",").map(Std.parseFloat);
		var pinPos:Array<Float> = positionsXml.get("pinPos").split(",").map(Std.parseFloat);
		var camPos:Array<Float> = positionsXml.get("camPos").split(",").map(Std.parseFloat);
		var threadPos:Array<Float> = positionsXml.exists("threadPos") ? positionsXml.get("threadPos").split(",").map(Std.parseFloat) : null;
		var storyType:String = xml.exists("storyType") ? xml.get("storyType") : "normal";
		var pictureData:Dynamic = {
			displayName: displayName,
			photoName: photoName,
			threadName: threadName,
			photoPos: photoPos,
			pinPos: pinPos,
			camPos: camPos,
			threadPos: threadPos,
			storyType: storyType
		};

		photoData.push(pictureData);
	
	
	}
}
