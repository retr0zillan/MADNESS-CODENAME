
function onPlaySingAnim(event) {
	

	if(idleSuffix=='-handless'){
		var anims = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];

		event.cancel();
	
		playAnim(anims[event.direction] + "-handless");
	}
	
		
	

	
}