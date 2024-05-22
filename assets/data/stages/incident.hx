import funkin.backend.FunkinSprite;

var deathJeb:FunkinSprite;
function postCreate(){
	strumLines.members[2].characters[0].alpha = 1/9999999;
	strumLines.members[2].characters[0].setPosition(-161, -5000);

	boyfriend.visible = false;
	deathJeb = new FunkinSprite(300,500);
	deathJeb.frames = Paths.getFrames('characters/Death jeb');
	deathJeb.scale.set(1.6,1.6);
	
	deathJeb.animation.addByPrefix('idle', 'crucified jebus', 24, true);
	deathJeb.animation.play('idle');
	insert(members.indexOf(dad), deathJeb);
	
}
function postUpdate(elapsed){
	camFollow.setPosition(dad.cameraOffset.x, dad.cameraOffset.y);
}
function beatHit(curBeat){
	var idlingJeb = deathJeb;
	var infronJeb = strumLines.members[2].characters[0];

	switch(curBeat)
	{

		case 187:
		
		
			FlxTween.tween(idlingJeb, {y:idlingJeb.y-9000}, 0.8, {ease:FlxEase.quadIn,onComplete:function(_) {
			}
		});

		case 188:
			infronJeb.alpha=1;
		case 190: 
			FlxTween.tween(infronJeb, {y:327}, 0.8, {ease:FlxEase.quadOut,onComplete:function(_) {

			}
		});

		case 320: 

			FlxTween.tween(infronJeb, {y:-5000}, 0.8, {ease:FlxEase.quadIn,onComplete:function(_) {

				remove(infronJeb);
				FlxTween.tween(idlingJeb, {y:500}, 0.8, {ease:FlxEase.quadOut,onComplete:function(_) {
					
				}
			});
			}
		});

	
			
			
	}
}