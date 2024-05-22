import funkin.game.PlayState;

var dumbass = 0;
function onNoteCreation(event){
	if(event.noteType == "deathwish"){
		var note = event.note;
		note.avoid = true;
	}

}
function onPlayerMiss(event){
	if (event.noteType == "deathwish"){
		event.cancel();
		event.note.strumLine.deleteNote(event.note);
	}
    

}
function onNoteHit(event)
	{
		if(event.noteType == "deathwish"){
			
			showSplash = true;

			misses = false;
			countAsCombo = false;
			countScore = false;
			event.cancelAnim();
		
			FlxG.sound.play(Paths.sound('strike'));
			var splashes = event.note;
			splashes.splash = "deathwish";
			dumbass++;
		
	
				health = 0.0009;
				trace('ye');

				if(PlayState.instance.boyfriend.curCharacter=="Coolhank")
					{
						//gameOver(boyfriend);


					}
					
			
			 if(dumbass>=3)
				{
					health = FlxG.save.data.defHealth == true ? 0:2;
					if(!FlxG.save.data.defHealth){
						ticks.members[currentCorp].animation.play('Burst');
						currentCorp = 1;
					}
				}
				


		
		}
		
	} 