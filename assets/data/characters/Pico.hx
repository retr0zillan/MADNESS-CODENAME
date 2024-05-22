import funkin.game.PlayState;

function onPlaySingAnim(event){
	if(animation.curAnim.name == 'shoot')
		event.cancel();
}