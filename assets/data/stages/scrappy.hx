import flixel.FlxSprite;
import funkin.game.PlayState;
import flixel.tweens.FlxEase;
var glitch:CustomShader = null;

function postCreate(){
	if (!Options.lowMemoryMode)
		{
			blackSqr = new FlxSprite(0,0).makeGraphic(FlxG.width * 4, FlxG.height*4, FlxColor.BLACK);
			blackSqr.alpha=0;
			add(blackSqr);
		}
}
function create() {
	if(!Options.gameplayShaders) {
		disableScript();
		return;
	}

	glitch = new CustomShader('glitchShader1');

	camGame.addShader(glitch);

	
}
var blackSqr:FlxSprite;
function update(elapsed:Float) {
	glitch.iTime = elapsed;
}
var shouldBop:Bool=false;
function beatHit(curBeat:Int) {

	if (!Options.lowMemoryMode)
	switch (curBeat){
		case 288:
			camGame.fade(FlxColor.BLACK, 3.8, false, function() {
				bg.destroy();
				bg2.alpha=1;
				screamer.alpha=1;
				screamer.screenCenter();
				screamer.cameras = [camHUD];
				screamer.playAnim('appear');

				screamer.animation.finishCallback = function(_){
					screamer.kill();
					FlxG.camera.fade(FlxColor.BLACK, 0.1, true);
				}
				
			});
			
		
			
			
	}
}


