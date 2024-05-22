import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.Json;
import flixel.FlxG;

var deimoSpr:FlxSprite;
var questSpr:FlxSprite;
var incorrectSpr:FlxSprite;
var correctSpr:FlxSprite;
var hellyeah:FlxTypeText;
var bg:FlxSprite;
var dia:FlxSprite;
var answersGroup:Array<FlxSprite> = [];
function create(){
	FlxG.sound.cache(Paths.sound('skuish'));
	preload('game/questionM/CORRECT');
	preload('game/questionM/diaBox');
	preload('game/questionM/elreytlin88');
	preload('game/questionM/INCORRECT');
	preload('game/questionM/Options');
	preload('game/questionM/QUESTION');
	preload('game/questionM/deimosQUESTION');



}
var daQuestion:Dynamic;
var blackList:Array<Int>=[];

//var data:Array<Dynamic>=[];
public function makeRandomQuestion(){
	
	hellyeah = new FlxTypeText(20, 577, 1178, '', 38, true);
        
	hellyeah.font = Paths.font("vcr.ttf");
	hellyeah.cameras = [camHUD];

	bg = new FlxSprite(0,0);
    bg.frames = Paths.getFrames('game/questionM/elreytlin88');
    bg.screenCenter();
    bg.scale.set(0.8,0.8);
    bg.animation.addByPrefix('appear','nigg instance',24, true);
    bg.animation.play('appear');
    bg.cameras = [camHUD];
               
    bg.antialiasing = true;
    add(bg);

	deimoSpr = new FlxSprite(0,0).loadGraphic(Paths.image('game/questionM/deimosQUESTION'));
	deimoSpr.screenCenter();

	deimoSpr.scale.set(1.2,1.2);
	deimoSpr.scrollFactor.set();
	deimoSpr.cameras = [camHUD];
	
	add(deimoSpr);
	questSpr = new FlxSprite(-52,57).loadGraphic(Paths.image('game/questionM/QUESTION'));
	questSpr.antialiasing = true;
	questSpr.cameras = [camHUD];


	add(questSpr);
	
	questSpr.alpha = 0;

	dia = new FlxSprite(-20,45);
	dia.frames = Paths.getFrames('game/questionM/diaBox');
	dia.animation.addByPrefix('appear','Text Intro',24, false);
	dia.animation.addByPrefix('idle','Text Idle',24, true);
	dia.antialiasing = true;
	dia.cameras = [camHUD];

	add(dia);


	
	var data = Json.parse(Assets.getText('assets/data/questions.json'));

	trace(data);
	var val = FlxG.random.int(0,data.length,blackList);
	daQuestion = data[val];
	blackList.push(val);
	trace('The question is '+ daQuestion.question);

	dia.alpha = 0;
        
              
	new FlxTimer().start(0.1, function(_) {
	questSpr.alpha=1;
	FlxG.sound.play(Paths.sound('skuish'));
	camHUD.shake(0.005);
	new FlxTimer().start(0.5,function(_)
		{
			questSpr.kill();
			hellyeah.color = FlxColor.WHITE;
			dia.alpha = 1;
			dia.animation.play('appear');
			dia.animation.finishCallback=function(_) {
				dia.animation.play('idle');
				add(hellyeah);
		  
				
			  
			
	
			  
			   hellyeah.sounds = [FlxG.sound.load(Paths.sound('blip'), 0.6)];
	
			   hellyeah.resetText(daQuestion.question);
			   
			   hellyeah.start(0.03, true);

			

			 

			 
			  
	
				hellyeah.completeCallback = function() {
					new FlxTimer().start(0.5, function(_)
						{
							bg.kill();
							deimoSpr.kill();
							dia.kill();
							hellyeah.kill();
							createAnswers();
							//addShit();

							//inC = true;
							//add(timer);
						   
						});
			   
				}
			   
				
			}
		
		});
		
   
	   
		
 
	});

}
var aPositions:Arrray<Dynamic>=[
[503, 498],
[653, 381],
[825, 491]
];

var aText:FlxText;
var editing:Int=2;
var answering:Bool=false;
var dakey:FlxKey;
function update(elapsed:Float) {
	
	if(answering){
		if (FlxG.keys.justPressed.ONE){
			verifyAnswer(1);

		}
		else if (FlxG.keys.justPressed.TWO){
			verifyAnswer(2);

		}
		else if (FlxG.keys.justPressed.THREE){
			verifyAnswer(3);

		}
	}
	
	//dakey.toString();
	


}
function verifyAnswer(key:Int){
	answering = false;
	answersGroup[key].animation.play('Selected');
	answersGroup[key].animation.finishCallback = function(_){
		answersGroup[key].animation.play('idle');

		if(key-1 == daQuestion.answer){
			trace('right answer');
			correctSpr = new FlxSprite(0,0).loadGraphic(Paths.image('game/questionM/CORRECT'));
			correctSpr.antialiasing = true;
			correctSpr.scale.set(0.7,0.7);
			add(correctSpr);
			correctSpr.alpha = 0;

		
		FlxTween.tween(correctSpr, {alpha:1}, 0.2);
		dad.playAnim('good',true);

         new FlxTimer().start(0.5, function(_)
          {   
            FlxTween.tween(correctSpr, {alpha:0}, 0.2, {onComplete:function(_){
				correctSpr.destroy();
				answersGroup[1].destroy();
				answersGroup[2].destroy();
				answersGroup[3].destroy();
				options[0].destroy();
				options[1].destroy();
				options[2].destroy();


			}});
                                   
              });
		}
		else{
			trace('wrong answer is'+daQuestion.answer+'and u answered'+key-1);

			incorrectSpr = new FlxSprite(0,0).loadGraphic(Paths.image('game/questionM/INCORRECT'));
			incorrectSpr.scale.set(0.7,0.7);
			incorrectSpr.antialiasing = true;
			add(incorrectSpr);
			incorrectSpr.alpha = 0;

			FlxTween.tween(incorrectSpr, {alpha:1}, 0.2);
			dad.playAnim('shoot',true);
					dad.animation.finishCallback=function(_){
						health = -1;
		
					}
			new FlxTimer().start(0.5, function(_)
				{
					FlxTween.tween(incorrectSpr, {alpha:0}, 0.2,{onComplete:function(_){
						incorrectSpr.destroy();
		
						answersGroup[1].destroy();
						answersGroup[2].destroy();
						answersGroup[3].destroy();
						options[0].destroy();
						options[1].destroy();
						options[2].destroy();
		
					}});
				
				
					new FlxTimer().start(0.4, function (_) {
						//FlxG.sound.play(Paths.sound('shot'));
					});
				});
		}

	}
trace(key);
}
function createBox(numba:Int){
	var answer = new FlxSprite(aPositions[numba-1][0],aPositions[numba-1][1]);
	answer.antialiasing=true;

	answer.frames = Paths.getFrames("game/questionM/Options");
	answer.animation.addByPrefix('appear','Option'+numba+' Appears',24, false);
	answer.animation.addByPrefix('idle','Option'+numba+'Idle',24, true);
	answer.animation.addByPrefix('Selected','Option'+numba+'Selected',24, false);
	answer.ID = numba;
	
	answer.scale.set(0.3,0.3);
	answer.updateHitbox();

	answersGroup[numba]=answer;
	//answersGroup.push(answer);

	add(answer);

	answer.animation.play('appear');

	answer.animation.finishCallback = function(_)
			{
				answer.animation.play('idle');
			}

			aText = new FlxText(100 +(numba-1*300) +70, 400, 270, daQuestion.options[numba-1], 26, true);
			aText.font = Paths.font("vcr.ttf");
		
			aText.clipRect = answer.rect;

			aText.x = (answer.frameWidth - aText.width) / 2 + answer.x - 460;
			aText.y = (answer.frameHeight - aText.height) / 2 + answer.y - 250;
			aText.alignment = "center";
			switch(numba)
			{
				case 1:
					
				   aText.angle = -30;
					case 2:
						
						aText.angle = -11;
						case 3: 
					
							aText.angle = 27;
			}
			
			aText.clipRect = answer.rect;
			add(aText);
			options.push(aText);
			answering = true;

}
var options:Array<FlxText>=[];
function createAnswers(){
	createBox(1);
	createBox(3);
	createBox(2);
	

}
var answersText:Array<FlxText>=[];
function preload(imagePath:String) {
    var graphic = FlxG.bitmap.add(Paths.image(imagePath));
    graphic.useCount++;
    graphic.destroyOnNoUse = false;
    graphicCache.cachedGraphics.push(graphic);
    graphicCache.nonRenderedCachedGraphics.push(graphic);
}