import funkin.game.PlayState;

function onPlaySingAnim(event){
	if(animation.curAnim.name == 'good' && animation.curAnim.name == 'shoot')
		event.cancel();
}