import funkin.game.PlayState;


function preload(imagePath:String) {
    var graphic = FlxG.bitmap.add(Paths.image(imagePath));
    graphic.useCount++;
    graphic.destroyOnNoUse = false;
    graphicCache.cachedGraphics.push(graphic);
    graphicCache.nonRenderedCachedGraphics.push(graphic);
}
var chroma:CustomShader = null;
function create() {




	preload('game/splashes/deathwish');

	preload('game/splashes/bulletnote');



}
var playShoot:Bool=false;

function onPlayerMiss(event){

	if(event.noteType == "bulletnote"){
		trace(event.direction);

		
		
		switch(event.direction){
			case 0:
				dad.playAnim('shootLEFT', true);
			case 1:
				dad.playAnim('shootDOWN', true);

			case 2: 
				dad.playAnim('shootUP', true);

			case 3:
				dad.playAnim('shootRIGHT', true);

		}
}

}
var shouldBop:Bool=false;
function beatHit(curBeat:Int) {

	if (!Options.lowMemoryMode){
		zombies.playAnim('bump');
		switch(curBeat){
			

			
		}
	}
}


