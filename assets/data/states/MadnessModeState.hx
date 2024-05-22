
import funkin.backend.FunkinSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.backend.scripting.ModState;
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
#if VIDEO_CUTSCENES
import hxvlc.flixel.FlxVideoSprite;
#end
import flixel.util.FlxTimer;
import openfl.system.System;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;
import openfl.net.FileFilter;
import flixel.util.FlxAxes;
import funkin.savedata.FunkinSave;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.addons.transition.TransitionData;
import funkin.editors.EditorPicker;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import sys.FileSystem;

var bg:FlxSprite;
var achievements:FlxSprite;
var blackBars:FlxSprite;
var diff:FlxSprite;
var grunt:FlxSprite;
var madnessText:FlxSprite;
var status:FunkinSprite;
var editorSpr:FlxSprite;
var gruntButton:FunkinSprite;
var done:FlxSprite;
var achievementsGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();

var row = ['Jebus', 'Scrape', 'Sanford', 'Deimos', 'Tricky', 'Romp','Mags', 'Phobos', 'Whitehank','Sun', 'All'];

function postCreate(){
	FlxG.camera.alpha = 0;
	FlxG.camera.zoom = 2;
	FlxTween.tween(FlxG.camera, {zoom: 1, alpha: 1}, 1, {ease: FlxEase.expoInOut});

	FlxG.mouse.visible = true;
     
	bg = new FlxSprite(-322,-178).loadGraphic(Paths.image('menus/madnessMode/bg'));
	bg.antialiasing=true;
	bg.scale.set(0.67,0.67);
	add(bg);

	madnessText = new FlxSprite(588,103);
	madnessText.frames = Paths.getFrames('menus/madnessMode/MadnessModeStuff');
	madnessText.animation.addByPrefix('idle', 'MadnessMode',24, true);
	madnessText.animation.play('idle');
	madnessText.antialiasing= true;
	madnessText.scale.set(0.67,0.67);

	madnessText.updateHitbox();

	add(madnessText);

  
	grunt = new FlxSprite(98,-128);
	grunt.frames = Paths.getFrames('menus/madnessMode/MadnessModeBF');
	grunt.animation.addByPrefix('idle', 'BFidle',24, true);
	grunt.animation.play('idle');
	grunt.antialiasing= true;
	grunt.scale.set(0.67,0.67);

	grunt.updateHitbox();

	add(grunt);

	status = new FunkinSprite(757,209);
	status.frames = Paths.getFrames('menus/madnessMode/MadnessModeStuff');
	status.animation.addByPrefix('off', 'Status_OFF',24, false);
	status.animation.addByPrefix('on', 'Status_ON',24, false);

	status.animation.play('off');
	status.antialiasing= true;
	status.scale.set(0.67,0.67);

	status.updateHitbox();

	add(status);

	


	gruntButton = new FunkinSprite(801,269);
	gruntButton.frames = Paths.getFrames('menus/madnessMode/MadnessModeStuff');
	gruntButton.animation.addByPrefix('off', 'Unselected_Button',24, false);
	gruntButton.animation.addByPrefix('on', 'Selected_Button',24, false);
	gruntButton.addOffset("on", 31,35);
	gruntButton.addOffset("off", 26.73,30.69);



	

	
	gruntButton.antialiasing= true;
	gruntButton.scale.set(0.67,0.67);
	
	gruntButton.updateHitbox();

	add(gruntButton);
	gruntButton.width = 80;
	gruntButton.height = 90;

	gruntButton.centerOrigin();
	done = new FlxSprite(1055,259);
	done.frames = Paths.getFrames('menus/madnessMode/MadnessModeStuff');
	done.animation.addByPrefix('idle', 'Done',24, false);

	done.animation.play('idle');
	done.antialiasing= true;
	done.scale.set(0.67,0.67);

	done.updateHitbox();

	add(done);

	achievements = new FlxSprite(545,372);
	achievements.frames = Paths.getFrames('menus/madnessMode/MadnessModeStuff');
	achievements.animation.addByPrefix('idle', 'AchievementsHolder0',24, true);

	achievements.animation.play('idle');
	achievements.antialiasing= true;
	achievements.scale.set(0.67,0.67);

	achievements.updateHitbox();

	add(achievements);


	createRows();
	add(achievementsGroup);

	
  
	blackBars = new FlxSprite(-320,-177).loadGraphic(Paths.image('menus/madnessMode/Menu-Bars'));
	blackBars.antialiasing=true;
	blackBars.scale.set(0.7,0.67);
	add(blackBars);

	syncMadnessMode();
}
function syncMadnessMode(){
	gruntButton.playAnim(madnessMode == true ? "on":"off");
	status.playAnim(madnessMode == true ? "on":"off");

}
function createRows() {
    for (i in 0...row.length) {
        var rowIndex = i < 6 ? 0 : 1;
        var xOffset = rowIndex == 0 ? 612 : 665;
        var yOffset = rowIndex == 0 ? 419 : 521;
        var framePrefix = row[i];

        var achievement = new FlxSprite(xOffset + (i % 6) * 97.65, yOffset);
        achievement.frames = Paths.getFrames('menus/madnessMode/MadnessModeStuff');
        achievement.animation.addByPrefix('locked', framePrefix + 'Blocked', 24, false);
        achievement.animation.addByPrefix('unlocked', framePrefix + 'Unlocked', 24, false);
        achievement.animation.play('locked');
        achievement.antialiasing = true;
        achievement.scale.set(0.67, 0.67);
        achievement.updateHitbox();

        achievementsGroup.add(achievement);
    }
}
var timeElapsed:Float = 0;
function postUpdate(elapsed:Float){
	timeElapsed += elapsed;
	madnessText.angle = Math.sin(timeElapsed * 0.5) * 1.2;
	var scale:Float = 0.8 + Math.cos(timeElapsed * 0.4) * 0.04;

	madnessText.scale.x = scale;
	madnessText.scale.y = scale;


		
	madnessText.x = madnessText.x + 0.04 * Math.sin((timeElapsed + 1 * 0.4) * Math.PI);
}
function update(elapsed:Float){
	if (controls.BACK||(FlxG.mouse.overlaps(done) && FlxG.mouse.justPressed))
		{
			FlxG.camera.flash(FlxColor.RED, 1);

			FlxTween.tween(FlxG.camera, {zoom: 2, alpha: 0}, 1, {ease: FlxEase.expoInOut});
			new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					FlxG.switchState(new MainMenuState());
				});
		}
		if(FlxG.mouse.overlaps(gruntButton)&& FlxG.mouse.justPressed){
			madnessMode = !madnessMode;
            syncMadnessMode();
        }
}