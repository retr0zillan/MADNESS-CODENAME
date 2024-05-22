

function onNoteHit(event)
	{
		if(event.noteType == "bulletnote"){
			
			event.cancelAnim();
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
		
	
			var splashes = event.note;
			showSplash = true;
			splashes.splash = "bulletnote";
			
		}
		
	} 