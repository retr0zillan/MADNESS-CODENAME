import funkin.backend.FunkinSprite;

var blackSpr:FunkinSprite;
var params:Dynamic;
function postCreate(){
	for (event in events) {
	
		if (event.name == 'BlackBg'){

			params = {
				in: event.params[1],
				layer: event.params[0]
			};
			trace(params.in);

			switch(params.layer){
				case "dad":
					insert(members.indexOf(dad),blackSpr = new FunkinSprite(0,0).makeSolid(1280, 720, 0xFF000000));

				case "bf":
					insert(members.indexOf(boyfriend),blackSpr = new FunkinSprite(0,0).makeSolid(1280, 720, 0xFF000000));

				case "gf":
					insert(members.indexOf(gf),blackSpr = new FunkinSprite(0,0).makeSolid(1280, 720, 0xFF000000));

			}
			blackSpr.scrollFactor.set();
			blackSpr.screenCenter();
			blackSpr.alpha = 1/999999;
			
			blackSpr.setGraphicSize(blackSpr.width * 4);
			
		
		}
	
	}


	}
	function onEvent(event) {

		if (event.event.name == 'BlackBg'){
		
			FlxTween.tween(blackSpr, {alpha:event.event.params[1] == "true"?1:0}, 0.2, {onComplete:function(_){
				if(event.event.params[1]=="false")
					blackSpr.destroy();
			}});

		}

	}