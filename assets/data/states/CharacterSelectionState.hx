import flixel.tweens.FlxEase;
import funkin.backend.system.Conductor;
import funkin.game.Character;
import funkin.backend.FunkinSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.xml.Access;

var bg:FlxSprite;
var light:FlxSprite;
var selectSpr:FlxSprite;
var thing:FlxSprite;
var done:FlxSprite;
var icon:FlxSprite;
var iconGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var artGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var descGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var bars:FlxSprite;
var desc:FlxSprite;
var art:FlxSprite;
var colsA:Array<FlxObject>=[];
var coll:FlxObject;
var list=['Icon_1_BF','Icon_2_Pico','Icon_3_CoolHank','Icon_4_Rich','Icon_5_Epico'];
var artlist=['1_BF','2_Pico','3_CoolHank','4_Rich','5_Epico','6_Yesnt','7_Cumi','8_Julian','9_Juan'];
var desclist=['TEXT_1_bf','TEXT_2_pico','TEXT_3_coolhank','TEXT_4_rich','TEXT_5_epico','TEXT_6_yesnt','TEXT_7_cumi','TEXT_8_julian','TEXT_9_juan'];
var charNames =['Bf', 'Pico', 'Coolhank', 'Rich', 'Epico'];
var yesnt:FunkinSprite;
var preview:Character;
var easterEgg:Bool = false;
//TODO make this dynamic .-.


var characterInfo:Array<Dynamic> = [{
	name: "Bf",
	x: 700,
	y: 450,
	scale: 0.9
},
{
	name: "Pico",
	x: 700,
	y: 450,
	scale: 0.8
},
{
	name: "Coolhank",
	x: 700,
	y: 450,
	scale: 0.9
},
{
	name: "Rich",
	x: 500,
	y: 220,
	scale: 0.5
},
{
	name: "Epico",
	x: 500,
	y: 240,
	scale: 0.6
}
];
function create(){
	Conductor.changeBPM(103);
	for(char in charNames)
		preload("characters/"+char);
}
function preload(imagePath:String) {
    var graphic = FlxG.bitmap.add(Paths.image(imagePath));
    graphic.useCount++;
    graphic.destroyOnNoUse = false;
    graphicCache.cachedGraphics.push(graphic);
    graphicCache.nonRenderedCachedGraphics.push(graphic);
}
function beatHit(curBeat){
	preview.playAnim("idle");
}
function retrieveInfo(who:String):Dynamic{
	for(info in characterInfo){
		if(info.name == who){
			return info;
			break;
		}
	}
	return null;
}
function postCreate() {
	FlxG.mouse.visible = true;
	add(bg = new FlxSprite(-319,-180).loadGraphic(Paths.image('menus/charSel/CharacterSelect_bg')));
	bg.antialiasing = true;

	preview = new Character(retrieveInfo(selectedChar).x,retrieveInfo(selectedChar).y, selectedChar, true);
	preview.scale.set(retrieveInfo(selectedChar).scale,retrieveInfo(selectedChar).scale);
	
	add(preview);


	//dest = y550 x-50;
	yesnt = new FunkinSprite(-100,700);
	yesnt.frames = Paths.getFrames('characters/Yesnt');
	yesnt.animation.addByPrefix('idle', "Idle", 0, false);
	yesnt.animation.play("idle");
	yesnt.angle = 40;
	add(yesnt);

	
	//TODO compact this
	if(FlxG.random.bool(0.1)){
		FlxTween.tween(yesnt, {y:550, x:-50}, 0.5, {ease:FlxEase.quadIn, onComplete:function(_){
			easterEgg=true;
			new FlxTimer().start(1, function(_){
				FlxTween.tween(yesnt, {y:700, x:-100}, 0.5, {ease:FlxEase.quadOut, onComplete: function(_){
					easterEgg=false;
					yesnt.destroy();
				}});
			
			});
		}});
	}


	add(light = new FlxSprite(-320,-176).loadGraphic(Paths.image('menus/charSel/CharacterSelect_lights')));
	light.antialiasing = true;
	light.blend = 3;

	selectSpr= new FlxSprite(66,50);
	selectSpr.frames = Paths.getFrames('menus/charSel/C_S_HUD');
	selectSpr.animation.addByPrefix('idle', 'SelectCharacter0', 24, false);
	selectSpr.animation.play('idle');
	add(selectSpr);

	thing= new FlxSprite(887,73);
	thing.frames = Paths.getFrames('menus/charSel/C_S_HUD');
	thing.animation.addByPrefix('idle', 'Stats0', 24, false);
	thing.animation.play('idle');
	add(thing);

	done= new FlxSprite(984,299);
	done.frames = Paths.getFrames('menus/charSel/C_S_HUD');
	done.animation.addByPrefix('idle', 'Done0', 24, false);
	done.animation.play('idle');
	add(done);

	
	var row = 0;
	var iconsPerRow = 6;

	for(i in 0...list.length){
		var x = 59 + ((i % iconsPerRow) * 100);
		var y = 134 + (100 * Math.floor(i / iconsPerRow));
		icon= new FlxSprite(x,y);
		icon.frames = Paths.getFrames('menus/charSel/C_S_HUD');
		icon.animation.addByPrefix('idle', list[i]+'0', 24, false);
		icon.animation.addByPrefix('selected', list[i]+'_selected0', 24, false);
		icon.ID = i;
		 icon.animation.play('idle');
		 icon.antialiasing=true;
		 icon.scale.set(0.67,0.67);
		 icon.updateHitbox();
		

		 iconGroup.add(icon);

		 art= new FlxSprite(-2,286);
		 art.frames = Paths.getFrames('menus/charSel/C_S_characterArt');
		 art.animation.addByPrefix('art', artlist[i], 24, false);
		 art.ID = i;
		 art.animation.play('art');
		 art.antialiasing=true;
		 art.scale.set(0.67,0.67);
		 art.updateHitbox();
		 art.kill();


		  artGroup.add(art);

		 desc= new FlxSprite(353,380);
		 desc.frames = Paths.getFrames('menus/charSel/C_S_characterTexts');
		 desc.animation.addByPrefix('desc', desclist[i], 24, false);
		 desc.ID = i;
		 desc.animation.play('desc');
		 desc.antialiasing=true;
		 desc.scale.set(0.67,0.67);
		 desc.updateHitbox();
		 desc.kill();


		 descGroup.add(desc);

		 coll = new FlxObject(icon.x +30, icon.y +30, icon.width*0.5, icon.height*0.5);
		 coll.ID = i;
		 add(coll);
		 colsA.push(coll);
	}
	add(iconGroup);
	add(artGroup);
	add(descGroup);



	add(bars = new FlxSprite(-319,-180).loadGraphic(Paths.image('menus/charSel/Menu-Bars')));

	for(spr in [bg, light, selectSpr, thing, done, bars]){
		spr.antialiasing = true;
		spr.scale.set(0.67,0.67);
	}
	


		iconGroup.members[curSel].color = 0xFFff5c5c;
		iconGroup.members[curSel].animation.play('selected');
	
		
		
}




function changeCharacter(char:String){
	if(preview.curCharacter!=char){
		FlxG.sound.play(Paths.sound('scrollMouse'));

		remove(preview);
		preview = new Character(retrieveInfo(char).x,retrieveInfo(char).y, char, true);
		preview.scale.set(retrieveInfo(char).scale,retrieveInfo(char).scale);
		add(preview);
	}
}

var soundPlayed:Boolean = false; 
var timeElapsed:Float = 0;
function postUpdate(elapsed){

	timeElapsed += elapsed;



	selectSpr.angle = Math.sin(timeElapsed * 0.5) * 1.2;

	var scale:Float = 0.7 + Math.cos(timeElapsed * 0.4) * 0.04;

	selectSpr.scale.x = scale;
	selectSpr.scale.y = scale;


		
	selectSpr.x = selectSpr.x + 0.04 * Math.sin((timeElapsed + 1 * 0.4) * Math.PI);


	
}
function update(elapsed) {

	FlxG.watch.addQuick('curChar', selectedChar);
	if(easterEgg && FlxG.mouse.overlaps(yesnt) && FlxG.mouse.justPressed){
		easterEgg=false;
		FlxG.sound.play(Paths.sound('cuack'));
	}
	if(controls.BACK||(FlxG.mouse.overlaps(done) && FlxG.mouse.justPressed)){
		FlxG.switchState(new MainMenuState());
	}
	for(col in colsA){
		if(FlxG.mouse.overlaps(col)){
			
			

				

			iconGroup.members[col.ID].animation.play('selected');
			changeCharacter(charNames[col.ID]);
			artGroup.members[col.ID].revive();
			descGroup.members[col.ID].revive();
			if(FlxG.mouse.justPressed){
				curSel = col.ID;
				selectedChar = charNames[col.ID];
				iconGroup.members[col.ID].color = 0xFFff5c5c;
		
				

			}

		}
		else{
		
			
			if(col.ID != curSel){
			
			iconGroup.members[col.ID].animation.play('idle');
			iconGroup.members[col.ID].color = 0xFFFFFF;

			}
			artGroup.members[col.ID].kill();
			descGroup.members[col.ID].kill();
			

		}
	}    
}
