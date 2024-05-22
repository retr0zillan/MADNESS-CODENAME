
import flixel.addons.transition.FlxTransitionableState;
import MoarUtils;
import Xml;
import flixel.FlxG;
static var selectedChar:String = 'Bf';
static var curSel:Int = 0;
static var globalWeekData:Array<WeekData>;
static var weekUnlocked:Array<Bool> = [true];
static var storyWeek:Int = 0;
static var storyAuto:Bool=false;
static var madnessMode:Bool = false;
function new(){
	if(FlxG.save.data.middleScroll==null)FlxG.save.data.middleScroll==true;
	if(FlxG.save.data.defHealth==null)FlxG.save.data.defHealth==true;
}
static var redirectStates:Map<FlxState, String> = [
    MainMenuState => "MainMenuState",
	FreeplayState => "FreeplayState",
    TitleState => "MainMenuState",
	StoryMenuState => "StoryBoardState",


];
static var MoarUtils:MoarUtils = new MoarUtils();
function preStateSwitch() {

    for (redirectState in redirectStates.keys())
        if (FlxG.game._requestedState is redirectState)
			{
				
				FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));

			}
}
function update(elapsed:Float)
    if (FlxG.keys.justPressed.F5) FlxG.resetState();