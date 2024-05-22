import funkin.game.PlayState;

function onPlaySingAnim(){
	FlxG.camera.shake(0.007);
	PlayState.instance.camHUD.shake(0.007);
}