

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
public var aimToggler:FunkinSprite;
public var aim:FunkinSprite;
var overlayCam:FlxCamera;
var enemiesContainer:Array<FunkinSprite>=[];

//thx magic man
var camOther:FlxCamera = new FlxCamera();

function preload(imagePath:String) {
    var graphic = FlxG.bitmap.add(Paths.image(imagePath));
    graphic.useCount++;
    graphic.destroyOnNoUse = false;
    graphicCache.cachedGraphics.push(graphic);
    graphicCache.nonRenderedCachedGraphics.push(graphic);
}

function create(){
    camOther.bgColor = 0;
    FlxG.cameras.add(camOther, false);

	
		FlxG.mouse.visible = false;
		aimToggler = new FunkinSprite(900, 700);
	
        aimToggler.frames = Paths.getFrames('game/shooting/ShootMode');
        aimToggler.animation.addByPrefix('on', 'Toogle', 24, false);
		aimToggler.animation.addByPrefix('off', 'Disable', 24, false);
		aimToggler.scale.set(0.4,0.4);
        aimToggler.animation.play('on');
		aimToggler.scrollFactor.set();
        aimToggler.antialiasing = true;
		add(aimToggler);

		aim = new FunkinSprite(900, 700);
	
        aim.frames = Paths.getFrames('game/shooting/ShootMode');
        aim.animation.addByPrefix('aim', 'Mirilla', 24, false);
		aim.cameras = [camOther];
		aim.scale.set(0.4,0.4);
		aim.updateHitbox();
        aim.animation.play('aim');
		aim.scrollFactor.set(0,0);
        aim.antialiasing = true;
		add(aim);

		preload('game/shooting/EnemyHelicopters');
		preload('characters/Enemies');

		


	
}

var attackInfo:Array<Dynamic>=[];
var attackTimer:FlxTimer;
var loseHealth:Bool = false;
function attackPlayer(type:Int, time:Float, attacker:FunkinSprite, data:Dynamic){

	attackTimer = new FlxTimer().start(time, function(_){
		trace('attacking');
		if(data.attackerdead||attacker==null||data.driverdead){
			if(loseHealth)loseHealth=false;
			trace('cancelling attack cuz attacker is dead or null');

			return;

		}
		else{
			switch(type){
				case 1:
					attacker.playAnim('attack');
					health -= 0.4;
					attacker.animation.finishCallback = function(_) {
						attacker.playAnim('idle');
					
						attackPlayer(type, time, attacker, data);
						
					

	
					}
				case 2: 
					attacker.playAnim('charge');
					new FlxTimer().start(1.2, function(_) {
						attacker.playAnim('attack');
						loseHealth=true;
	
					});
				case 3: 
					attacker.playAnim('aim');
					attacker.animation.finishCallback = function(_){
						attacker.playAnim('attack');
						health -= 0.5;
						attacker.animation.finishCallback = function(_){
							attacker.playAnim('idle');

							attackPlayer(type, time, attacker, data);

						}

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

	attackInfo.push(data);
	
	FlxTween.tween(type==3 ? attacker:helicopter, {x:destination.x,y:destination.y}, 7, {onComplete: function(_){
		attackPlayer(type,FlxG.random.int(2,4), attacker, data);
		

	}, ease:FlxEase.quadOut});
	

}
//enemy1 goes with enemy3
//enemy2 goes with enemy 4
//enemy5 goes alone
var beingAttacked:Bool=false;
function moveObject(obj:FunkinSprite){
	FlxG.watch.addQuick('heliPos', 'X:'+obj.x+' Y:'+obj.y);
	if(FlxG.keys.pressed.I){
		obj.y -= 1;
	}
	if(FlxG.keys.pressed.K){
		obj.y += 1;

	}
	if(FlxG.keys.pressed.L){
		obj.x += 1;

	}
	if(FlxG.keys.pressed.J){
		obj.x -= 1;

	}
}
var timeElapsed:Float = 0;
function beatHit(curBeat:Int){
	for(data in attackInfo){
		
		var attacker = data.attacker;
		var driver = data.driver;
		if(driver!=null){
			if(driver.animation.curAnim.name !='spawn'&&driver.animation.curAnim.name!='attack'&&driver.animation.curAnim.name!='charge'&&driver.animation.curAnim.name!='dies')
				driver.playAnim('idle');
		}
		if(attacker!=null){
			if(attacker.animation.curAnim.name !='spawn'&&attacker.animation.curAnim.name!='attack'&&attacker.animation.curAnim.name!='charge'&&attacker.animation.curAnim.name != 'dies'
				&&attacker.animation.curAnim.name != 'dies1' &&attacker.animation.curAnim.name != 'dies2' && attacker.animation.curAnim.name != 'aim')
			attacker.playAnim('idle');
		}
		
	}


	if(FlxG.random.bool(20))
		createAttack(FlxG.random.int(1,3));
		//createAttack(2);

	


	

	
	
	

}
function createAttacker(type:Int, data:Dynamic){
	new FlxTimer().start(FlxG.random.int(2, 4), function(_){
		var newAttacker = new Character(0,0, 'attacker'+type);
		if(newAttacker.animation.getByName('spawn')!=null)
			{
				newAttacker.playAnim('spawn');
				newAttacker.animation.finishCallback=function(_){
					newAttacker.playAnim('idle');		
				}
	
			}
			else
				newAttacker.playAnim('idle');
	
			if(type == 1){
				insert(members.indexOf(bfCopter)+1, newAttacker);
	
		
				data.attacker = newAttacker;
				data.attackerdead = false;
	
				attackPlayer(data.id, FlxG.random.int(2,4), newAttacker, data);
			}
			else if(type == 2){
				insert(members.indexOf(data.helicopter), newAttacker);
	
	
				data.attacker = newAttacker;
				data.attackerdead = false;
	
				attackPlayer(data.id, FlxG.random.int(2,4), newAttacker, data);
			}
			else if(type == 3){
				trace('creating jetpack');
				insert(members.indexOf(bfCopter)+1, newAttacker);

				newAttacker.setPosition(4000, 200);
				data.attacker = newAttacker;
				data.attackerdead = false;
				FlxTween.tween(newAttacker, {x:200,y:400}, 7, {onComplete: function(_){
				
					//attackPlayer(type,FlxG.random.int(2,4), newAttacker, data);
					
			
				}, ease:FlxEase.quadOut});

			}
	
			

	
	});
	
						
}
function update(elapsed:Float){

	if(loseHealth)
		health -= 0.002;

	if(deimos.getAnimName()!='shootBack'&&deimos.getAnimName()!='shootFront'){
		if(!aim.visible)
			deimos.playAnim('bumps');
		else
			deimos.playAnim('shootIdle');
	}

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
	aim.x = mouseWorldPos.x - 40;

	aim.y = mouseWorldPos.y - 35;


	if(FlxG.keys.justPressed.X){
		aimToggler.animation.play(aimToggler.animation.curAnim.name == 'on'? 'off':'on');

	}


	if(FlxG.mouse.justPressed && aim.visible){
		FlxG.sound.play(Paths.sound('getShot'));
		//FlxG.camera.shake(0.02,0.2);
		camGame.shake(0.01,0.5);

	
		
		for(data in attackInfo){
			
			if(data.driver!=null)
			if(FlxG.mouse.overlaps(data.driver) && !data.driverdead){
				loseHealth=false;

				trace('driver from attack '+data.id+' got shot');
				data.driverdead = true;
				data.driver.playAnim('dies');
				data.driver.animation.finishCallback = function(_){
					
					FlxTween.tween(data.helicopter, {x:4000, y:4000}, 7, {onComplete: function(_){
						attackInfo.remove(data);
					

						remove(data.driver);
						remove(data.attacker);
						remove(data.helicopter);

						

			
					}, ease: FlxEase.quadOut});
				}

				if(data.id == 1){
					deimos.playAnim('shootFront');
					trace('shooting front');
				
				}
				else if(data.id == 2){
					deimos.playAnim('shootBack');
					trace('shooting back');
	
				}
				deimos.animation.finishCallback=function(_) {
					deimos.playAnim('shootIdle');
				
	
				}
			
			}
			if(FlxG.mouse.overlaps(data.attacker) && !data.attackerdead && !data.driverdead){
				loseHealth=false;
				data.attackerdead = true;
				if(data.attacker.animation.getByName('dies1')!=null)
				data.attacker.playAnim('dies'+FlxG.random.int(1,2));
				else
					data.attacker.playAnim('dies');

				if(data.id==3){
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
				else
					data.attacker.animation.finishCallback = function(_){
				
						remove(data.attacker);
						createAttacker(data.id, data);
					//data.attacker = null;
					if(data.id == 1){
	
						deimos.playAnim('shootFront');
						trace('shooting front');
					
					}
					else if(data.id == 2){
	
						deimos.playAnim('shootBack');
						trace('shooting back');
		
					}



				}
				
				deimos.animation.finishCallback=function(_) {
					deimos.playAnim('shootIdle');
					
	
				}
				trace('attacker from attack '+data.id+' got shot');
			}
			
			
		}
	
	
	}
}