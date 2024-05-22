
import flixel.addons.transition.FlxTransitionableState;
public static var selectedChar:String = 'Bf';
public static var curSel:Int = 0;
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
function preStateSwitch() {

    for (redirectState in redirectStates.keys())
        if (FlxG.game._requestedState is redirectState)
			{
				
				FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));

			}
}
function update(elapsed:Float)
    if (FlxG.keys.justPressed.F5) FlxG.resetState();