function update(elapsed){
	timeElapsed +=elapsed;

	y += 0.2 * Math.cos((timeElapsed + 0 * 0.02) * Math.PI);
	x += 0.2 * Math.sin((timeElapsed + 0 * 0.02) * Math.PI);

}
var timeElapsed:Float = 0;
