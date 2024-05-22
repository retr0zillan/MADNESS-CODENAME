function preload(imagePath:String) {
    var graphic = FlxG.bitmap.add(Paths.image(imagePath));
    graphic.useCount++;
    graphic.destroyOnNoUse = false;
    graphicCache.cachedGraphics.push(graphic);
    graphicCache.nonRenderedCachedGraphics.push(graphic);
}

function create(){
	preload('stages/betrayedpart1/FGromps2');
	preload('stages/betrayedpart1/AngryRompEffect');
	preload('stages/betrayedpart1/BGromps');

}
function postCreate(){
	filter.blend = 0;
}

