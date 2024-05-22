import flixel.addons.transition.FlxTransitionableState;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.FlxSprite;
import funkin.backend.MusicBeatState;

var logo:FlxSprite;
var daTip:FlxText;

function create(){

	

	logo = new FlxSprite(0, 0);
	logo.loadGraphic(Paths.image('menus/loading/loading'+FlxG.random.int(2,9)));
	logo.antialiasing = true;
	logo.updateHitbox();
	add(logo);


	
	var uselessTips:Array<String> = CoolUtil.coolTextFile('assets/data/tips.txt');
	daTip = new FlxText(1200, 470, 400);
	daTip.text = uselessTips[FlxG.random.int(0, uselessTips.length - 1)];
	daTip.setFormat(Paths.font("Fliped.otf"), 29, FlxColor.RED, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	daTip.scrollFactor.set();
	daTip.alpha = 0;
	add(daTip);

	

	FlxTween.tween(daTip, {alpha: 1, x: 790}, 0.5, {ease:FlxEase.quadOut});

	#if !debug
	new FlxTimer().start(FlxG.random.int(2, 5), function(_){

		MusicBeatState.skipTransIn = true;
		MusicBeatState.skipTransOut = true;
		FlxG.switchState(new PlayState());
	});
	#else 
	
	MusicBeatState.skipTransIn = true;
	MusicBeatState.skipTransOut = true;
	FlxG.switchState(new PlayState());
	#end

}