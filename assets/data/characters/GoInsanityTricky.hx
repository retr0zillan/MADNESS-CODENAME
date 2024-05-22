import funkin.game.PlayState;

function onPlaySingAnim(){
	FlxG.camera.shake(0.005);
	PlayState.instance.camHUD.shake(0.005);
	PlayState.instance.boyfriend.playAnim('resist');
}