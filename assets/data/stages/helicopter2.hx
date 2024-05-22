
import funkin.game.Character;
import funkin.backend.FunkinSprite;
import flixel.addons.display.FlxBackdrop;
import funkin.game.PlayState;
import flixel.util.FlxAxes;
var sky:FunkinSprite;
var mountains:FlxBackdrop;
var clouds:FlxBackdrop;
public var deimos:FunkinSprite;
var clouds2:FlxBackdrop;
var particlesB:FlxBackdrop;
var particlesF:FlxBackdrop;
var flayer2:FunkinSprite;
public var bfCopter:FunkinSprite;

function create()
	{
		importScript("data/scripts/helicoptersMechanic");

	
		 sky = new FunkinSprite(-600, -200).loadGraphic(Paths.image('stages/helicopter/CIELO'));
        sky.antialiasing = true;
        sky.scale.set(1.4,1.4);
        sky.scrollFactor.set(0.9, 0.9);
        sky.active = false;
		insert(members.indexOf(dad),sky);
  
        mountains = new FlxBackdrop(Paths.image('stages/helicopter/GROUND'));
		mountains.spacing.set(-100,0); 
		mountains.repeatAxes = 0x01;
		
		
        mountains.setPosition(-795.3999999998, -57);
        mountains.antialiasing = true;
        mountains.velocity.set(180, 0);
       
		insert(members.indexOf(dad),mountains);
  

         clouds= new FlxBackdrop(Paths.image('stages/helicopter/CLOUDS 1'));
		 clouds.moves = true;
		
        clouds.setPosition(-474, -623);
        clouds.antialiasing = true;
        clouds.velocity.set(200, 0);
		insert(members.indexOf(dad),clouds);

		deimos = new FunkinSprite(355, 326);
		
        deimos.frames = Paths.getFrames('characters/helideimos');
        deimos.animation.addByPrefix('bumps', 'Bumping', 24, true);
		deimos.animation.addByPrefix('miss', 'Miss', 24, false);
        deimos.animation.addByPrefix('shootIdle', 'ShootingDeimos_Idle', 24, true);
        deimos.animation.addByPrefix('shootFront', 'Shoot1_ShootingDeimos', 24, false);
        deimos.animation.addByPrefix('shootBack', 'Shoot2_ShootingDeimos', 24, false);

		deimos.addOffset('bumps', 0,0);
		deimos.addOffset('shootIdle', 20,23);
		deimos.addOffset('shootFront', 61,94);
		deimos.addOffset('shootBack', 71,37);
		deimos.addOffset('miss', 1,-17);

        deimos.antialiasing = true;
		insert(members.indexOf(dad),deimos);


         bfCopter = new FunkinSprite(-657, -647);
        bfCopter.frames = Paths.getFrames('stages/helicopter/helicopter SB');
        bfCopter.animation.addByPrefix('fly', 'Helicopter', 24, true);
        bfCopter.animation.play('fly');
        bfCopter.antialiasing = true;
    
       
	
		//add(bfCopter);
		insert(members.indexOf(PlayState.instance.comboGroup),bfCopter);

         clouds2 = new FlxBackdrop(Paths.image('stages/helicopter/CLOUDS 2'));
		 clouds2.moves = true;

        clouds2.setPosition(-562, -306);
        clouds2.antialiasing = true;
        clouds2.velocity.set(210, 0);

		add(clouds2);



      
         particlesB = new FlxBackdrop(Paths.image('stages/helicopter/Snfo_Back_dust'));
		 particlesB.moves = true;

        particlesB.setPosition(-372, -187);
        particlesB.antialiasing = true;
        particlesB.velocity.set(500, 500);
       
	
		add(particlesB);


        
      
         particlesF = new FlxBackdrop(Paths.image('stages/helicopter/Snfo_front_dust'));
		 particlesF.moves = true;

        particlesF.setPosition(-605, -217);
        particlesF.antialiasing = true;
        particlesF.velocity.set(900, 900);
       
	
		add(particlesF);


        

         flayer2 = new FunkinSprite(-447, -535);
        flayer2.loadGraphic(Paths.image('stages/helicopter/EFECTO'));
        flayer2.antialiasing = true;
        flayer2.scale.set(1.5,1.5);
      
	
		add(flayer2);

        
	}
	var timeElapsed:Float = 0;

	function beatHit(curBeat:Int){
		//deimos.playAnim(aimToggler.animation.curAnim.name = 'on' ? 'bumps':'shootIdle');
	

	
	}
	function update(elapsed:Float){
		timeElapsed +=elapsed;

		bfCopter.y = bfCopter.y + 0.4 * Math.cos((timeElapsed + 0 * 0.02) * Math.PI);
		boyfriend.y = bfCopter.y +950;
		dad.y = bfCopter.y +540;
		deimos.y = bfCopter.y +960;

		
	}
