import flixel.util.FlxTimer;
import funkin.game.PlayState;
var daGrunts:Array<Character>=[];
function create() {
	speaker2.flipX = true;
	guillo.addOffset('hole', 0, 0);
	guillo.addOffset('falls', 25, 23);

	guillo.playAnim('static');
}

function postCreate(){
	var dumbass:Array<Dynamic> = [1,2,3];

	for(i in 0...3){
		var grunt:Character = new Character(0,0, 'Bgrunt' +dumbass[i], false);
		grunt.antialiasing=true;
		grunt.scrollFactor.set(0.9, 0.9);
		grunt.playAnim('yeah');
		grunt.alpha= 1/9999;
		insert(members.indexOf(boyfriend)+1,grunt);
		daGrunts.push(grunt);

		switch(i){
			case 0:
				grunt.setPosition(356,200);
			case 1:
				grunt.setPosition(877,268);

			case 2:
				grunt.setPosition(1681,44);

		}
	  }

}
function killGrunt(who:Int){
	var grunt:Character = daGrunts[who];
	grunt.playAnim('death');
	grunt.animation.finishCallback=function(_){
		remove(grunt);
	}
}
function lastTrans() {
	camHUD.fade(0xFF000000, 0.5, false, function(){
		new FlxTimer().start(1, function(_){
			camHUD.fade(0xFF000000, 0.5, true);
			dad.playAnim('intro');
			boyfriend.playAnim('intro');


		});

		dad.setPosition(605,-122);
		boyfriend.setPosition(1318,180);
	});



}

function clearStage(){
	guillo.destroy();
	bg.destroy();
	speaker.destroy();
	speaker2.destroy();
	chairs.destroy();
	publicP.destroy();

}
function transOut() {
	defaultCamZoom = 0.8;
	trace('trans out');
	boyfriend.setPosition(1329,158);
	dad.setPosition(524,158);

	dad.alpha = 1;
	ye=false;
	camHUD.fade(0xFF000000, 0.5, true);

	for(g in daGrunts)g.alpha=1;
	dad.forceIsOnScreen = true;
}
function transIn(){
	guillo.playAnim('falls');
	guillo.animation.finishCallback = function(_){
		guillo.playAnim('hole');
		dad.playAnim('bye');
		dad.animation.finishCallback=function(_){
			dad.alpha = 0;
			camHUD.fade(0xFF000000, 0.5, false, function(){
				clearStage();
				

			});

		}

	}

}
var ye:Bool=true;
function postUpdate(elapsed) {
	//boyfriend.forceIsOnScreen = true;
	//dad.forceIsOnScreen = true;
	if(ye)
	camFollow.x = 500;
}