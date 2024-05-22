

function create() {
	importScript("data/scripts/dexQuestions");
	
	
}
function update(elapsed){
	if(FlxG.keys.justPressed.F){
	
			makeRandomQuestion();
		
	}
}
function beatHit(curBeat:Int) {
	
}