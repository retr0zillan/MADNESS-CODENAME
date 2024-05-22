import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;

var hand:FlxSprite;
var sqrs:FlxTypedGroup<FlxSprite>= new FlxTypedGroup();
var sizes:Array<Float>=[
80.95,
73.8,
63.65,
57.55,
53.35
];
var charge:Int = 0;
function postCreate(){
	trace('hank mechanic loaded');
	hand = new FlxSprite(-10,400);
	hand.frames = Paths.getFrames('game/charactersMassets/PunchMetter');
	hand.antialiasing=true;
	hand.animation.addByPrefix('empty', 'COOL PUNCH NORMAL', 24, true);
	hand.animation.addByPrefix('full', 'COOL PUNCH FULL', 24, true);
	hand.animation.play('empty');
	hand.scrollFactor.set();
	hand.cameras = [tacCam];
	insert(members.indexOf(healthBarBG)+1,hand);

	for(i in 0...5){
		var sqr = new FlxSprite(hand.x + 37  + (i*8),hand.y + 275 - (i*35)).makeGraphic(sizes[i], 29, 0xFFFF1515);
		sqr.ID=i;
		sqr.alpha = 1/999999999;
		sqrs.add(sqr);


	}

	sqrs.cameras = [tacCam];

	insert(members.indexOf(healthBarBG)+1,sqrs);

}
function chargeAb(){
	if(charge<5){
		charge++;
		FlxTween.tween(sqrs.members[charge-1],{alpha:1}, 0.4, {ease:FlxEase.circIn});
		if(charge==5) hand.animation.play('full');
	}
}
function onPlayerHit(e){
	var prob:Float = e.rating == "sick" ? 10 : 0.4;

	if(e.note.wasGoodHit && FlxG.random.bool(prob))chargeAb();

		

}
function update(elapsed){
	if(FlxG.keys.justPressed.SPACE && charge==5){
		boyfriend.playAnim('punch', true, "SING");
	
		hand.animation.play('empty');
		if(health<2)health += 0.5;
			for(sqr in  sqrs){
				FlxTween.tween(sqr,{alpha:0}, 0.4, {ease:FlxEase.circOut, onComplete:function(_){
					if(sqr.ID == sqrs.members.length-1)
					charge=0;

				}});

			}
	}
}