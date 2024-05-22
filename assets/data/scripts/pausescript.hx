
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.ui.FunkinText;
import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxAxes;
import funkin.backend.FunkinSprite;
import funkin.editors.charter.Charter;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextAlign;
var pauseCam = new FlxCamera();
var holder:FlxSprite;
var options = ["Restart", "Quit"];
var opts:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var wow:Array<String> = ['Restart Song','Exit to menu'];

function create(event){
	event.cancel();
	cameras = [];
	FlxG.cameras.add(pauseCam, false);
	pauseCam.bgColor = 0x88000000;
	//pauseCam.alpha = 0;


	holder = new FlxSprite(400,400).loadGraphic(Paths.image("menus/pause/GamePaused"));
	holder.screenCenter();
	holder.antialiasing=true;
	add(holder);


	for(i in 0...options.length){
		var option = new FlxSprite(holder.x +40 + (i * 260),holder.y + 150);
		option.frames = Paths.getFrames("menus/pause/"+ options[i]);
		option.animation.addByPrefix("idle", options[i] + "0", 24, false);
		option.animation.addByPrefix("selected", options[i] + "Selected", 24, false);
		option.animation.play("idle");
		option.antialiasing= true;
		option.ID = i;
		opts.add(option);

	}

	var quotes:Array<String> = CoolUtil.coolTextFile('assets/data/PauseQuotes.txt');

	daQuote = new FlxText(0, 0, 300);
	daQuote.size = 20;
	daQuote.text = quotes[FlxG.random.int(0, quotes.length - 1)];
	daQuote.font = Paths.font("impact.ttf");
	daQuote.alignment = FlxTextAlign.LEFT;
	daQuote.color = 0xFF9F9F9F;
	daQuote.scrollFactor.set();
	daQuote.setPosition(holder.x - daQuote.fieldWidth/2 + 250, holder.y + daQuote.fieldHeight + 70);
	add(daQuote);
	//fuente: Impact
	//Color #9F9F9F
	add(opts);
	cameras = [pauseCam];

	changeSelection(0);

	trace(menuItems);
}
var daQuote:FlxText;
function onSelectOption(event){
	event.cancel();
	var daSelected:String = wow[curSelected];

	switch(daSelected){
		case "Restart Song":
				trace("restart");
				parentDisabler.reset();
				PlayState.instance.registerSmoothTransition();
				FlxG.resetState();
		case "Exit to menu":
			trace("exit");

			if (PlayState.chartingMode && Charter.undos.unsaved)
				PlayState.instance.saveWarn(false);
			else {
				PlayState.resetSongInfos();
				if (Charter.instance != null) Charter.instance.__clearStatics();
				
				pauseCam.flash(FlxColor.RED, 1);

				FlxTween.tween(FlxG.camera, {zoom: 2, alpha: 0}, 1, {ease: FlxEase.expoInOut});
				FlxTween.tween(pauseCam, {zoom: 2, alpha: 0}, 1, {ease: FlxEase.expoInOut});

				new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());

					});
			}
	}
}

function update(elapsed:Float){
	if(controls.BACK)
		close();
	if (controls.ACCEPT) 
		selectOption();
		
	
	if(controls.LEFT_P)
		changeSelection(-1);
	if(controls.RIGHT_P)
		changeSelection(1);

}
function destroy() {
	FlxG.cameras.remove(pauseCam);
}
function changeSelection(change) {
	curSelected += change;

	if (curSelected < 0)
		curSelected = options.length - 1;
	if (curSelected >= options.length)
		curSelected = 0;
	for(o in opts){
		o.animation.play("idle");
		if(curSelected == o.ID)
			o.animation.play("selected");

	}
}