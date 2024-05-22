import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;
import funkin.backend.FunkinSprite;
import funkin.game.PlayState;

var glitch:CustomShader = null;
var blackSpr:FunkinSprite;


function create() {
	importScript("data/scripts/scrapeHands");

	gf.playAnim('glitch');

	//preload('assets/images/game/handsM/scrapehands');

	if(Options.gameplayShaders) {
		glitch = new CustomShader('glitchShader1');

		camGame.addShader(glitch);
		camHUD.addShader(glitch);

	}

	

}

function postCreate(){
insert(members.indexOf(dad),blackSpr = new FunkinSprite(bg.x,bg.y).makeSolid(1280, 720, 0xFF000000));
blackSpr.scrollFactor.set();
blackSpr.screenCenter();
blackSpr.alpha = 1/999999;

}
function blackTransition(isIn:Bool){
	trace(isIn);
	 
	FlxTween.tween(blackSpr, {alpha: isIn == "true"?1:0}, 0.2);





}
function update(elapsed:Float) {
	glitch.iTime = elapsed;
	if(FlxG.keys.justPressed.F){
		startGrab();
	}
}
var shouldBop:Bool=false;
function beatHit(curBeat:Int) {

	gf.playAnim('glitch');
	scientist.playAnim('bump');
}


