import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;
import funkin.backend.FunkinSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.Json;
import flixel.graphics.frames.FlxAtlasFrames;

import flixel.FlxG;
import funkin.backend.assets.Paths;
function preload(imagePath:String) {
    var graphic = FlxG.bitmap.add(Paths.image(imagePath));
    graphic.useCount++;
    graphic.destroyOnNoUse = false;
    graphicCache.cachedGraphics.push(graphic);
    graphicCache.nonRenderedCachedGraphics.push(graphic);
}
var hands:FunkinSprite;

function create() {


	//preload('assets/images/game/handsM/scrapehands');

	hands = new FunkinSprite(0,-400);
	hands.frames = Paths.getFrames('game/handsM/scrapehands');
	hands.animation.addByPrefix('idle', 'Idle', 24, true);
	hands.animation.addByPrefix('dies', 'Dies', 24, false);
	hands.animation.addByPrefix('catch', 'Catching', 24, false);
	hands.addOffset('idle', -139, -153);
	hands.addOffset('catch', -224, -234);
	hands.addOffset('dies', -37, -158);
	hands.alpha = 0;
	hands.playAnim('idle');
	add(hands);



}
var handsUpdater:Bool = false;
var fuckenTween:FlxTween;

public function startGrab(){
		hands.x = -156;

		dad.idleSuffix = '-handless';
		hands.alpha=1;
		handsUpdater = true;
  
		fuckenTween = FlxTween.tween(hands, {x:boyfriend.x-60}, 2, {onComplete:function(_){
		  hands.playAnim('catch');
		 
		}});
	 
}
function update(){
	if(handsUpdater){

		if(hands.animation.curAnim.curFrame < 15 && FlxG.mouse.justPressed){
		 
			dad.idleSuffix = '';

			fuckenTween.cancel();
			boyfriend.playAnim('dodgeLEFT');
		  hands.playAnim('dies');
		  hands.animation.finishCallback = function(_){
			hands.alpha=0;
			hands.playAnim('idle');
  
  
		  }
		  trace('attacked the hand');
		  handsUpdater = false;
		}
		else if(hands.animation.curAnim.curFrame > 16){
			FlxG.camera.flash(FlxColor.RED, 1);
			hands.alpha=0;
			health -= 0.3;
			hands.playAnim('idle');
			dad.idleSuffix = '';

  
		  trace('hand reached bf');
		  handsUpdater = false;
  
  
		}
	  }
}