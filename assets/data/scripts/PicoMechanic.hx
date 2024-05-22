import flixel.text.FlxText;
import funkin.backend.FunkinSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;


var timingCrap:FunkinSprite;
var bullets:FlxSprite;
var notes:FlxTypedGroup<FlxSprite>=new FlxTypedGroup();
var threshold:FlxObject;
var mag:Int = 20;
var bulletsText:FlxText;
function postCreate(){
	trace('mechanic loaded');
	
	timingCrap = new FunkinSprite(healthBarBG.x - 600,healthBarBG.y -70);
	timingCrap.frames = Paths.getFrames("game/charactersMassets/TimingBar");
	timingCrap.antialiasing=true;
	timingCrap.animation.addByPrefix("normal", "TIMINGBARregular",24,true);
	timingCrap.animation.addByPrefix("hit", "TIMINGBARhit",24,false);
	timingCrap.addOffset("hit", 0, 13);
	timingCrap.addOffset("normal", 0, 0);

	timingCrap.animation.play('normal');
	timingCrap.cameras = [tacCam];
	if(!downscroll) timingCrap.y -= 20;
	insert(members.indexOf(healthBarBG)+1,timingCrap);

	bullets = new FlxSprite(healthBarBG.x - 350,healthBarBG.y -90);
	bullets.scale.set(0.7,0.7);
	bullets.frames = Paths.getFrames("game/charactersMassets/TimingBar");
	bullets.antialiasing=true;
	bullets.animation.addByPrefix("normal", "BULLETSLEFT",24,true);
	bullets.animation.play('normal');
	bullets.cameras = [tacCam];
	insert(members.indexOf(timingCrap)+1,bullets);

	bulletsText = new FlxText(bullets.x + 125, bullets.y, 0, Std.string(mag), 15);
	bulletsText.color = 0xFFFFFF;
	bulletsText.font = Paths.font('impact.ttf');
	insert(members.indexOf(bullets)+1,bulletsText);
	bulletsText.cameras = [tacCam];


	for(i in 0...2){
		//basepos1 timingCrap.x +70
		//basepos2 timingCrap.x +370
		//destpos timingCrap.x +220
		var note = new FlxSprite(i==0?timingCrap.x +70:timingCrap.x +370,timingCrap.y + 25);
		note.frames = Paths.getFrames("game/charactersMassets/TimingBar");
		note.antialiasing=true;
		note.animation.addByPrefix("normal", "TIMINGBARnote",24,true);
		note.animation.play('normal');
		note.cameras = [tacCam];
		note.ID = i;
		note.flipX = i == 0 ? false: true;
		notes.add(note);

		note.width = 40;
		note.height = 40;

		basePos1 = timingCrap.x +70;
		basePos2 = timingCrap.x +370;
		destPos = timingCrap.x +220;


	}

	add(notes);


}
var basePos1:Float;
var basePos2:Float;
var destPos:Float;
function postUpdate(elapsed) {
	bulletsText.text = Std.string(mag);
	if (curBeat % 2 == 0) {
        for (note in notes) {
            var distanceToMove:Float = (destPos - note.x) / 2;
            var velocity:Float = distanceToMove / (Conductor.stepCrochet / 1000);
            note.velocity.x = velocity;
        }

		
    }

	if (FlxG.keys.justPressed.SPACE && mag>0) {
			
		if(curBeat % 2 == 0){
		
			mag--;
			boyfriend.playAnim('shoot', true, "SING");
			if(health<2)
			health += 0.25;
			timingCrap.playAnim('hit');
			timingCrap.animation.finishCallback = function(_) {
				timingCrap.playAnim('normal');
			}
		}
		else{
			health -= 1.5;
			mag -= 5;
			trace('dumb');

		}
	
	
}


    for (note in notes) {
        note.update(elapsed);
        if ((note.velocity.x > 0 && note.x >= destPos) || (note.velocity.x < 0 && note.x <= destPos)) {
            note.x = note.ID == 0 ? basePos1 : basePos2;
            note.velocity.x = 0;
        }
    }
}