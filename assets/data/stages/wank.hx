
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
function postCreate(){
	var cielo:FlxSprite = new FlxSprite(-200, -435).loadGraphic(Paths.image('stages/wank/capa1Cielo'));
	cielo.antialiasing = true;
	cielo.scrollFactor.set();
	cielo.scale.set(3,3);

	insert(members.indexOf(dad), cielo);

	var clouds:FlxBackdrop = new FlxBackdrop(Paths.image('stages/wank/Hardcore BG clouds'),0x01,0,0);
	clouds.setPosition(-3744,153);
	clouds.velocity.set(-1000, 0);

	clouds.antialiasing = true;
	clouds.scale.set(2.8,2.8);
	insert(members.indexOf(dad), clouds);


	var edif1:FlxBackdrop = new FlxBackdrop(Paths.image('stages/wank/capa2edif'),0x01,0,0);
	edif1.antialiasing =true;
	edif1.setPosition(-5268,-428);

	edif1.scale.set(2.7,2.7);
	edif1.velocity.set(-3000, 0);
	insert(members.indexOf(dad), edif1);

	var mont = new FlxBackdrop(Paths.image('stages/wank/capa3mont'),0x01,0,0);
	mont.antialiasing=true;
	mont.scale.set(4.5,4.5);
	mont.velocity.set(-4000, 0);
	mont.setPosition(-8341,0);

	insert(members.indexOf(dad), mont);


	var mont2 = new FlxBackdrop(Paths.image('stages/wank/capa5mont2'),0x01,0,0);
	mont2.antialiasing=true;
	mont2.scale.set(4.7,4.7);
	mont2.velocity.set(-4500, 0);
	mont2.setPosition(-9842,68);

	insert(members.indexOf(dad), mont2);

	var elcarrocherlo = new FlxSprite(-433, 313);
	elcarrocherlo.frames = Paths.getFrames('stages/wank/NEWCar');
	elcarrocherlo.animation.addByPrefix('drive', 'CARRO', 24, true);
	elcarrocherlo.animation.play('drive');

	elcarrocherlo.antialiasing = true;

	elcarrocherlo.active = true;

	insert(members.indexOf(dad), elcarrocherlo);
	remove(boyfriend);
	insert(members.indexOf(elcarrocherlo), boyfriend);
}