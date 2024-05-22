import funkin.savedata.FunkinSave;
import haxe.io.Path;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import funkin.backend.FunkinText;
import Xml;
import flixel.text.FlxText;
import funkin.backend.assets.AssetsLibraryList;


public var localWeeks:Array<WeekData> = [];


function postCreate() {
	loadXMLs();
	for(week in localWeeks){
		trace("week called"+week.name + "has songs"+week.songs);
	}

	
	
}

function update(elapsed){
	if(controls.BACK){
	
		FlxG.switchState(new MainMenuState());

	}
}
public function getWeeksFromSource(weeks:Array<String>, source:funkin.backend.assets.AssetsLibraryList.AssetSource) {
	var path:String = Paths.txt('freeplaySonglist');
	var weeksFound:Array<String> = [];
	if (Paths.assetsTree.existsSpecific(path, "TEXT", source)) {
		var trim = "";
		weeksFound = CoolUtil.coolTextFile(Paths.txt('weeks/weeks'));
	} else {
		weeksFound = [for(c in Paths.getFolderContent('data/weeks/weeks/', false, source)) if (Path.extension(c).toLowerCase() == "xml") Path.withoutExtension(c)];
	}
	
	if (weeksFound.length > 0) {
		for(s in weeksFound){
			weeks.push(s);
	

		}
		return false;
	}
	return true;
}
public function isSpace(s:String, pos:Int):Bool {

	var c = s.charCodeAt(pos);
	return (c > 8 && c < 14) || c == 32;
}
public function trim(s:String):String {

	var l = s.length;
	var r = 0;
	while (r < l && isSpace(s, l - r - 1)) {
		r++;
	}
	if (r > 0) {
		return s.substr(0, l - r);
	} else {
		return s;
	}
	
}
function get_innerData(xml:Xml) {
	var it = xml.iterator();
	if (!it.hasNext())
		throw " does not have data";
	var v = it.next();
	if (it.hasNext()) {
		var n = it.next();
		// handle <spaces>CDATA<spaces>
		if (v.nodeType == Xml.PCData && n.nodeType == Xml.CData && trim(v.nodeValue) == "") {
			if (!it.hasNext())
				return n.nodeValue;
			var n2 = it.next();
			if (n2.nodeType == Xml.PCData && trim(n2.nodeValue) == "" && !it.hasNext())
				return n.nodeValue;
		}
		throw " does not only have data";
	}
	if (v.nodeType != Xml.PCData && v.nodeType != Xml.CData)
		throw " does not have data";
	return v.nodeValue;
}

public function loadXMLs() {
	// CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
	var weeks:Array<String> = [];
	if (getWeeksFromSource(weeks, false))
		getWeeksFromSource(weeks, true);

	for(k=>weekName in weeks) {

		var week = null;
		
		week = Xml.parse(Assets.getText(Paths.xml('weeks/weeks/'+weekName))).firstElement();
		
		var weekObj:WeekData = {
            name: week.get("name"),
            id: weekName,
            sprite: week.get("sprite"),
            chars: [null, null, null],
            songs: [],
            difficulties: ['easy', 'normal', 'hard']
        };

		var songNodes = week.elementsNamed("song");
        if (songNodes != null && songNodes.hasNext()) {
            var k2 = 0;
            while (songNodes.hasNext()) {
                var song = songNodes.next();
                if (song == null) continue;

                var name = MadnessUtils.get_innerData(song);

				weekObj.songs.push({
					name: name,
					hide: song.get("hide", "false") == "true"
				});

                k2++;
            }
        }
	
		localWeeks.push(weekObj);


		/*
		if (week == null) continue;

		if (!week.has.name) {
			Logs.trace('Story Menu: Week at index ${k} has no name. Skipping...', WARNING);
			continue;
		}
		var weekObj:WeekData = {
			name: week.att.name,
			id: weekName,
			sprite: week.getAtt('sprite').getDefault(weekName),
			chars: [null, null, null],
			songs: [],
			difficulties: ['easy', 'normal', 'hard']
		};

		var diffNodes = week.nodes.difficulty;
		if (diffNodes.length > 0) {
			var diffs:Array<String> = [];
			for(e in diffNodes) {
				if (e.has.name) diffs.push(e.att.name);
			}
			if (diffs.length > 0)
				weekObj.difficulties = diffs;
		}

	
		for(k2=>song in week.nodes.song) {
			if (song == null) continue;
		
				var name = song.innerData.trim();
				if (name == "") {
					Logs.trace('Story Menu: Song at index ${k2} in week ${weekObj.name} has no name. Skipping...', WARNING);
					continue;
				}
				weekObj.songs.push({
					name: name,
					hide: song.getAtt('hide').getDefault('false') == "true"
				});
		
		}
		if (weekObj.songs.length <= 0) {
			Logs.trace('Story Menu: Week ${weekObj.name} has no songs. Skipping...', WARNING);
			continue;
		}
		this.weeks.push(weekObj);
		*/
	}
}
