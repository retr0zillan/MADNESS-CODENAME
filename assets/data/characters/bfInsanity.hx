import funkin.game.PlayState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import funkin.backend.system.Conductor;

function onGetCamPos(){
	FlxTween.tween(PlayState.instance.camGame, {zoom: 1.1}, (Conductor.stepCrochet * 4 / 2000), {ease: FlxEase.elasticInOut});
}
