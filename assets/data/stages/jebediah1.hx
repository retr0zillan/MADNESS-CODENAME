import funkin.backend.shaders.CustomShader;
import funkin.game.PlayState;
var newCam:FlxCamera = new FlxCamera();

function preload(imagePath:String) {
    var graphic = FlxG.bitmap.add(Paths.image(imagePath));
    graphic.useCount++;
    graphic.destroyOnNoUse = false;
    graphicCache.cachedGraphics.push(graphic);
    graphicCache.nonRenderedCachedGraphics.push(graphic);
}
function create() {
	newCam.bgColor = 0;
    FlxG.cameras.add(newCam, false);
	zombiepunch.cameras = [newCam];
	crack.cameras = [newCam];

	FlxG.sound.cache(Paths.sound('strike'));

	preload('game/splashes/deathwish');


}
var water:CustomShader;
var updater:Float = 0;
function postCreate(){
	//triangleFill.setPosition(triangle.x,triangle.y-44);

	

	//trace(triangleFill.getPosition());
}
function update(elapsed:Float) {
	updater += elapsed;

}
function onPostNoteCreation(event) {  
   
}
var shouldBop:Bool=false;
function beatHit(curBeat:Int) {

	if (!Options.lowMemoryMode){
		if(shouldBop)zombies.playAnim('bump');
		switch(curBeat){
			case 209:
				gf.alpha = 0;
			camGame.flash(FlxColor.WHITE, 1);
			
			memories.alpha = 1;
		
			
			case 238:
				camGame.flash(FlxColor.WHITE, 1);
				memories.destroy();
				zombies.alpha = 1;
				gf.alpha = 1;

				zombies.playAnim('appear');
				zombies.animation.finishCallback = function(_){
					shouldBop=true;
				}

			case 250: 
				

				zombiepunch.alpha = 1;
				zombiepunch.playAnim('punch');

				new FlxTimer().start(0.7, function(_){
					crack.alpha = 1;

			
				  });
				zombiepunch.animation.finishCallback = function(_){
					
					zombiepunch.kill();
				}

			
		}
	}
}


