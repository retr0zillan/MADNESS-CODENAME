import flixel.FlxSprite;

var pizzaSpr:FlxSprite;
var anims:Map<Int, String>=[
	4 => "pizza completa",
	3 => "tres rebanadas",
	2 => "dos rebanadas",
	1 => "dos rebanadas",
	0 => "vacia",
];
var totalPizza:Int = 4;
function postCreate(){
	trace('mechanic loaded');
	pizzaSpr = new FlxSprite(healthBarBG.x -1050,healthBarBG.y - 100);
	pizzaSpr.frames = Paths.getFrames('game/charactersMassets/pizza');
	for(numba => anim in anims){
		pizzaSpr.animation.addByPrefix(Std.string(numba), anim, 24, true);

	}
	pizzaSpr.scale.set(0.7,0.7);
	pizzaSpr.animation.play(Std.string(totalPizza));
	pizzaSpr.cameras = [tacCam];
	pizzaSpr.antialiasing = true;
	pizzaSpr.scrollFactor.set();
	insert(members.indexOf(healthBarBG)+1,pizzaSpr);


}
function update(elapsed){
	if(FlxG.keys.justPressed.SPACE && totalPizza>0 && health < 2){
		trace('pizza time');
		totalPizza--;
		pizzaSpr.animation.play(Std.string(totalPizza));
		health += 0.3;

	}
}