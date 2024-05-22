

import flixel.addons.effects.chainable.FlxRainbowEffect;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import funkin.game.Character;
import flixel.tweens.FlxTween;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;
import funkin.backend.FunkinSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.Json;
import flixel.graphics.frames.FlxAtlasFrames;
import funkin.game.PlayState;
import flixel.util.FlxGradient;
import funkin.backend.system.RotatingSpriteGroup;
import flixel.text.FlxText.FlxTextBorderStyle;

public var aimToggler:FunkinSprite;
public var aim:FunkinSprite;
var overlayCam:FlxCamera;
var enemiesContainer:Array<FunkinSprite>=[];
var killGroup:RotatingSpriteGroup;
var killCombo:Int = 0;
//thx magic man
var camOther:FlxCamera = new FlxCamera();
var raimbow:FlxRainbowEffect;


function postCreate(){
    camOther.bgColor = 0;
    FlxG.cameras.add(camOther, false);

	
		FlxG.mouse.visible = false;
		aimToggler = new FunkinSprite(250, downscroll == true ? -50:550);
	
        aimToggler.frames = Paths.getFrames('game/shooting/ShootMode');
        aimToggler.animation.addByPrefix('on', 'Toogle', 24, false);
		aimToggler.animation.addByPrefix('off', 'Disable', 24, false);
		aimToggler.scale.set(0.3,0.3);
        aimToggler.animation.play('on');
		aimToggler.scrollFactor.set();
        aimToggler.antialiasing = true;
		aimToggler.cameras = [camOther];

		add(aimToggler);

		aim = new FunkinSprite(900, 700);
        aim.loadGraphic(Paths.image('game/shooting/aim')); 
		aim.scale.set(0.3,0.3);
		aim.updateHitbox();
		aim.scrollFactor.set();
        aim.antialiasing = true;
		aim.cameras = [camOther];
		add(aim);

		graphicCache.cache(Paths.image("game/shooting/EnemyHelicopters"));
		graphicCache.cache(Paths.image("characters/Enemies"));


		comboText =new FlxText(-200,80,0, "1x");
		comboText.antialiasing=true;
		comboText.font = Paths.font("BulletInYourHead.ttf");
		comboText.color = 0xFFffffff;
		comboText.setBorderStyle(FlxTextBorderStyle.SHADOW, 0xFF000000, 4, 1);
		comboText.size = 120;
		comboText.cameras = [camOther];
		comboText.text = "x"+killCombo;
		add(comboText);
		


}
var toleranceTime:FlxTimer = new FlxTimer();
function showKillCombo(){
if(comboText.x==20)return;
FlxTween.tween(comboText, {x:20}, 0.2, {ease:FlxEase.quadIn});


toleranceTime.start(5, function(_){
	FlxTween.tween(comboText, {x:-200}, 0.2, {ease:FlxEase.quadIn, onComplete:function(_){
		killCombo = 0;

	}});

});

	



		
	
}
var comboText:FlxText;
var attackInfo:Array<Dynamic>=[];
var loseHealth:Bool = false;
var attackTimer:FlxTimer = new FlxTimer();
function attackPlayer(type:Int, time:Float,  data:Dynamic){
	attacker = data.attacker;

	attackTimer.start(time, function(_){
		if(data.attackerdead||attacker==null||data.driverdead){
			trace('cancelling attack cuz attacker is dead or null');
			return;
		}
			switch(type){
				case 1:
					trace("bazooka shooter goes boom");
					attacker.playAnim('attack');
					health -= 0.4;
					attacker.animation.finishCallback = function(_) {
						attacker.playAnim('idle');
					
						attackPlayer(type, time, data);
						
					

	
					}
				case 2: 
				
						attacker.playAnim("charge");
						new FlxTimer().start(1, function(_){
							if(attacker.animation.curAnim.name != "attack" && !data.attackerdead && !data.driverdead){
								attacker.playAnim('attack');
								loseHealth = true;
								trace("gunner shooting");

							}
							
						});
						
						
					
						//attacker.playAnim('charge');
						//new FlxTimer().start(1.2, function(_) {
						//});
					
					
						

				case 3: 
					attacker.playAnim('aim');
					attacker.animation.finishCallback = function(_){
						attacker.playAnim('attack');
						health -= 0.5;
						attacker.animation.finishCallback = function(_){
							attacker.playAnim('idle');

							attackPlayer(type, time, data);

						}

					}
	
			}
		
		

	});
}
public function createAttack(type:Int){
	for(data in attackInfo){
		if(type == data.id){
			//trace('no clones');
			return;

		}
	}
	
	var helicopter = new FunkinSprite(4000,4000);
	helicopter.frames = Paths.getFrames('game/shooting/EnemyHelicopters');
	helicopter.animation.addByPrefix('idle', 'HelicopterEnemy'+type, 24, true);
	helicopter.antialiasing=true;
	
	helicopter.animation.play('idle');



	var driver = new Character(0,0, 'helidriver'+type);
	driver.playAnim('idle');


	var attacker = new Character(0,0, 'attacker'+type);


	if(attacker.animation.getByName('spawn')!=null)
		{
			attacker.playAnim('spawn');
			attacker.animation.finishCallback=function(_){
				attacker.playAnim('idle');

				
			
			}
		}
		else
			attacker.playAnim('idle');

	


		var destination = new FlxObject(0,0);
		var data:Dynamic;
		data = {
			id: type,
			helicopter: helicopter,
			driver: driver,
			attacker: attacker,
			driverdead: false,
			attackerdead: false,
	
			died: false,
			canBeShot: true,
		};
	switch(type){
		case 1:
			
		
		
				destination.setPosition(143,-381);
				insert(members.indexOf(bfCopter)+1, helicopter);
				insert(members.indexOf(bfCopter)+1, driver);
				insert(members.indexOf(bfCopter)+1, attacker);
			

		case 2:
			destination.setPosition(-661,-82);

			driver.width = 150;
			driver.height = 100;
			attacker.width = 100;
			attacker.height = 100;
			attacker.centerOrigin();
			driver.centerOrigin();

			insert(members.indexOf(dad), driver);
			insert(members.indexOf(dad), attacker);
			insert(members.indexOf(dad), helicopter);
		
		case 3:
				attacker.setPosition(4000, 200);
				destination.setPosition(200,400);

				remove(helicopter);
				remove(driver);

				insert(members.indexOf(bfCopter)+1, attacker);
				data = {
					id: type,
		
					attacker: attacker,
				
					attackerdead: false,
			
					died: false,
					canBeShot: true,
				};
	
	}

	var destinationTween:FlxTween = FlxTween.tween(type==3 ? attacker:helicopter, {x:destination.x,y:destination.y}, 7, {onComplete: function(_){
		attackPlayer(type,FlxG.random.int(2,4), data);
		

	}, ease:FlxEase.quadOut});
	 data.destinationTween = destinationTween;
	attackInfo.push(data);
	
	

}
//enemy1 goes with enemy3
//enemy2 goes with enemy 4
//enemy5 goes alone
var beingAttacked:Bool=false;
var timeElapsed:Float = 0;
function beatHit(curBeat:Int){
	for(data in attackInfo){
		
		var attacker = data.attacker;
		var driver = data.driver;
		if(driver!=null && !data.driverdead){
			if(driver.animation.curAnim.name !='spawn'&&driver.animation.curAnim.name!='attack'&&driver.animation.curAnim.name!='charge'&&driver.animation.curAnim.name!='dies')
				driver.playAnim('idle');
		}
		if(attacker!=null && !data.attackerdead){
			if(attacker.animation.curAnim.name !='spawn'&&attacker.animation.curAnim.name!='attack'&&attacker.animation.curAnim.name!='charge'&&attacker.animation.curAnim.name != 'dies'
				&&attacker.animation.curAnim.name != 'dies1' &&attacker.animation.curAnim.name != 'dies2' && attacker.animation.curAnim.name != 'aim')
			attacker.playAnim('idle');
		}
		
	}


	if(FlxG.random.bool(killCombo >=3 ?95 : 20))
	createAttack(FlxG.random.int(1,3));
		//createAttack(2);
	
		

	


	

	
	
	

}
function createAttacker(type:Int, data:Dynamic){
	
	
		var newAttacker = new Character(0,0, 'attacker'+type);
		data.attacker = newAttacker;
		data.attackerdead = false;

		if(newAttacker.animation.getByName('spawn')!=null)
			{
				newAttacker.playAnim('spawn');
				newAttacker.animation.finishCallback=function(_){
					newAttacker.playAnim('idle');		
				}
	
			}
			else
				newAttacker.playAnim('idle');
	
			switch(type){
				case 1:
				insert(members.indexOf(bfCopter)+1, newAttacker);
				data.attacker = newAttacker;
				data.attackerdead = false;
				attackPlayer(data.id, FlxG.random.int(2,4), data);
				case 2:
				insert(members.indexOf(data.helicopter), newAttacker);
				data.attacker = newAttacker;
				data.attackerdead = false;
				attackPlayer(data.id, FlxG.random.int(2,4), data);
				case 3: 
					trace('creating jetpack');
					insert(members.indexOf(bfCopter)+1, newAttacker);
	
					newAttacker.setPosition(4000, 200);
					data.attackerdead = false;
					FlxTween.tween(newAttacker, {x:200,y:400}, 7, {onComplete: function(_){
					
						//attackPlayer(type,FlxG.random.int(2,4), newAttacker, data);
						
				
					}, ease:FlxEase.quadOut});
	
			}
			
	
			

	
	
	
						
}
function postUpdate(elapsed:Float){
	timeElapsed += elapsed;





		comboText.x +=  0.04 * Math.sin((timeElapsed + 1 * 0.4) * Math.PI);
		comboText.angle = Math.sin(timeElapsed * 0.5) * 1.2;
			

}
var showNotes:Bool = true;

function update(elapsed:Float){

	comboText.text = "x"+killCombo;

	FlxG.watch.addQuick("losehealth", loseHealth);

	aim.scale.set(lerp(aim.scale.x, 0.3, 0.5),lerp(aim.scale.y, 0.3, 0.5));

	if(loseHealth)
		health -= 0.006;



	for(data in attackInfo){
		
	
			var attacker = data.attacker;
			var driver = data.driver;
			if(data.id == 1){
			
				if(driver!=null)
				driver.setPosition(data.helicopter.x + 300,data.helicopter.y+850);
				if(attacker!=null)
				attacker.setPosition(data.helicopter.x + 700,data.helicopter.y+850);	
			}
			if(data.id == 2){
			
				if(driver!=null)
				driver.setPosition(data.helicopter.x + 60,data.helicopter.y+280);
				if(attacker!=null)
				attacker.setPosition(data.helicopter.x + 300,data.helicopter.y+280);	
				
	
			}
		
		
	}

	



	aim.visible = aimToggler.animation.curAnim.name == 'off'? true : false;
	var mouseWorldPos = FlxG.mouse.getPositionInCameraView(camOther);
	aim.x = mouseWorldPos.x - 60;

	aim.y = mouseWorldPos.y - 50;


	if(FlxG.keys.justPressed.X){
	

		aimToggler.animation.play(aimToggler.animation.curAnim.name == 'on'? 'off':'on');
		deimos.playAnim(aim.visible==true ? "bumps" : "shootIdle");
	

		FlxTween.tween(camNotes, {alpha: aim.visible == true ? 1 : 0}, 0.2);
	
		playerStrums.cpu = !playerStrums.cpu;

	}


	if(FlxG.mouse.justPressed && aim.visible){
	
		FlxG.sound.play(Paths.sound('shot'+FlxG.random.int(1,3)));
	
		//FlxG.camera.shake(0.02,0.2);
		camGame.shake(0.01,0.3, null, true, 0x01);

		aim.color = 0xFFd20e00;
		new FlxTimer().start(0.1, function(_)aim.color=0xFFFFFF);

		aim.scale.set(0.5, 0.5);

		for(data in attackInfo){
			
			if(data.driver!=null)
			if(FlxG.mouse.overlaps(data.driver) && !data.driverdead){
				loseHealth=false;
				songScore += 300;
				toleranceTime.reset(5);
				killCombo++;
				showKillCombo();

				trace('driver from attack '+data.id+' got shot');
				data.driverdead = true;
				data.driver.playAnim('dies');
				data.driver.animation.finishCallback = function(_){
				if(data.destinationTween.active)data.destinationTween.cancel();
	
					FlxTween.tween(data.helicopter, {x:4000, y:4000}, 7, {onComplete: function(_){
						attackInfo.remove(data);
					

						remove(data.driver);
						remove(data.attacker);
						remove(data.helicopter);

						

			
					}, ease: FlxEase.quadOut});
				}

				deimos.playAnim(data.id == 1 ? "shootFront" : "shootBack");

				deimos.animation.finishCallback=function(_) {
					deimos.playAnim('shootIdle');
				

				}
			
			}
			if(FlxG.mouse.overlaps(data.attacker) && !data.attackerdead && !data.driverdead){
				
				loseHealth=false;
				songScore += 100;
				killCombo++;
				toleranceTime.reset(2);

				showKillCombo();

				data.attackerdead = true;
				if(data.destinationTween.active)data.destinationTween.cancel();

				
				data.attacker.playAnim(data.attacker.animation.exists('dies1') ? "dies"+FlxG.random.int(1,2): "dies" );
				switch(data.id){
					default: 
						deimos.playAnim(data.id == 1 ? "shootFront" : "shootBack");

						data.attacker.animation.finishCallback = function(_){
							

							remove(data.attacker);
							
							new FlxTimer().start(FlxG.random.int(1,4), function(_){
								createAttacker(data.id, data);

							});
						//data.attacker = null;
						
					}
					
					
					trace('attacker from attack '+data.id+' got shot');

					case 3: 
						deimos.playAnim('shootFront');

						new FlxTimer().start(2, function(_){
							
							attackInfo.remove(data);
	
							remove(data.attacker);
							//createAttacker(data.id, data);
	
	
						});
						FlxTween.tween(data.attacker, {x:4000, y:4000}, 8, {onComplete: function(_){
							trace('jetpack man is down');
						}, ease: FlxEase.quadOut});
				}
				deimos.animation.finishCallback=function(_) {
					deimos.playAnim('shootIdle');
	
				}

			}
			
			
		}
	
	
	}
}